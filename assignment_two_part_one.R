### ACA: Script from Dr. Bolker that loads Excel data 
library(readxl)
library(dplyr)
### ACA: added tidyverse
library(tidyverse)

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

unclean_data <- all_vals_frame |> summarise(fwhm = get_fwhm(dist, gray_val),
                            .by = c(coord, val))

print(unclean_data, n = 180)
str(unclean_data)

### ACA: the coordinate column represents the x- and y- axes of individual synaptic vesicles. The value column represents individual synaptic vesicles and the fwhm column represents the full-width distance (microns) for the x- and y- axes at data points = or > than the half-maximum intensity signal of a synaptic vesicle. 
### ACA: first, I will arrange the coordinates so that the x- and y- axes are not mixed.

unclean_data_one <- unclean_data |> 
  arrange(coord, val) 

print(unclean_data_one, n = 180)

### ACA: Second, I next check if the R classes and structures are correct.

str(unclean_data_one)

### ACA: The coordinate column is a character column, however, it should be a factor column. The x- and y- axes are categorical.
### ACA: Also, the val column represents vesicle_id number. Each x,n and y,n values (where n = vesicle_id) pertain to the same synaptic vesicles. The data would be cleaner if pivoted so that x- and y- axes values correspond to the vesicle_id.

unclean_data_two <- unclean_data_one |> 
  rename(vesicle_id = val) |> 
  pivot_wider(id_cols = vesicle_id, names_from = coord, values_from = fwhm)

print(unclean_data_two, n = 180)

str(unclean_data_two)

### ACA: The vesicle_id column represents discrete synaptic vesicles that are unrelated to other synaptic vesicles in the column. However, RStudio structure interprets it as a continuous variable. It should be treated as a factor.
###ACA: This error was even more pronounced in the unclean_data_one tibble. Here, RStudio interprets that both the x- or y- axes increase with vesicle_id number.

ggplot(unclean_data_two, aes(x = vesicle_id, y = y)) +
  geom_point() +
  geom_smooth()

ggplot(unclean_data_one, aes(x = coord, y = val)) +
  geom_point()

### ACA: RStudio treats vesicle_id as a numeric column and as a continuous variable. It should be a factor.

clean_data <- unclean_data_two |> 
  mutate(vesicle_id = factor(vesicle_id))

str(clean_data)

saveRDS(clean_data, "cleaned_vesicle_fwhm_data.rds")

