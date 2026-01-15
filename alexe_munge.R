library(readxl)
library(dplyr)

fn <- "Blue Gel1_Cell2 Deconvolved Data.xlsx"
dd <- read_excel(fn, col_names=FALSE) |> as.matrix()

## make a logical matrix of the same shape
head_cells <- apply(dd, 1:2, \(x) grepl("[xy]V[0-9]+", x))
head_cell_pos <- which(head_cells, arr.ind = TRUE)

get_mat <- function(pos, data = dd)  {
  i <- pos[1]
  j <- pos[2]
  hdr <- unname(data[i,j])
  coord <- substr(hdr, 1, 1)
  val <- readr::parse_number(hdr)
  ## find first blank (NA) cell, account for extra headers etc.
  nvals <- which(is.na(data[i:(nrow(data)),j]))[1] - 4
  dist <- as.numeric(data[(i+3):(i+2+nvals),j])
  gray_val <- as.numeric(data[(i+3):(i+2+nvals),j+1])
  tibble(coord,val,dist,gray_val)
}

all_vals_list <- apply(head_cell_pos, 1, get_mat)
all_vals_frame <-  dplyr::bind_rows(all_vals_list)

## full width at half-max:
##  linear approximation of half-max only works if we
##   have a *monotonic* curve.   Have to search for minimum,
##   cut off vals at that point
get_fwhm <- function(dist, gray_val, plot.it = FALSE) {
  maxpos <- which.max(gray_val)
  maxval <- max(gray_val)
  lwr_ind <- 1:maxval
  ## vals go from largest to smallest
  get_pos <- function(ind) {
    curv <- diff(sign(diff(gray_val[ind])))
    lastval <- length(ind)
    if (any(curv>0)) lastval <-  which(curv>0)[1]
    ind <- ind[1:lastval]
    approx(gray_val[ind], dist[ind], xout = maxval/2)
  }
  lwr <- get_pos(rev(1:maxpos))
  upr <- get_pos((maxpos+1):length(dist))
  if (plot.it) {
    plot(dist, gray_val, type = "b")
    abline(h = c(maxval, maxval/2), lty = 2, col = 2)
    abline(v = c(lwr$y, upr$y), lty = 2, col = 2)
  }
  upr$y-lwr$y
}

## testing
tst <- all_vals_list[[1]]
get_fwhm(tst$dist, tst$gray_val, plot.it = TRUE)

all_vals_frame |> summarise(fwhm = get_fwhm(dist, gray_val),
                            .by = c(coord, val))
