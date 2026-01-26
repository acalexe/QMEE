library(tidyverse)
library(ggplot2) ## BMB: ggplot2 is redundant after loading tidyverse

### ACA: dataset_one and dataset_two contain synaptic vesicle counts for individual synaptic terminals. The synaptic vesicle type was 3D-segmented using ImageJ and each dataset corresponds to synaptic vesicle count from different cells.

dataset_one <- read.csv("synaptic_terminal_data_one.csv")

dataset_two <- read.csv("synaptic_terminal_data_two.csv")

### ACA: I am comparing the relative proportion of synaptic vesicle type per individual synaptic terminal. Since synaptic terminals are heterogeneous in the total number and type of synaptic vesicles, I first normalize the synaptic vesicle type for each synaptic terminal.

dataset_one_normalized <- dataset_one |> 
  group_by(synaptic.terminal.id) |> 
  mutate(total_vesicles = sum(count),
         proportion = count / total_vesicles) |> 
  ungroup()
## BMB: could use .by here ...

dataset_two_normalized <- dataset_two |> 
  group_by(synaptic.terminal.id) |> 
  mutate(total_vesicles = sum(count),
         proportion = count / total_vesicles) |> 
  ungroup()

### ACA: I am combining the two datasets into one data frame. I used bind_rows(). Not sure if there is a better option.

dataset_all_normalized <-  bind_rows(
  dataset_one_normalized |> mutate(cell = "cell 1"),
  dataset_two_normalized |> mutate(cell = "cell 2")
)

## BMB: here's a trick for repeating less:
library(magrittr)
normalize <- . %>% mutate(total_vesicles = sum(count),
                          proportion = count / total_vesicles,
                          .by = synaptic.terminal.id)

## this creates a function-like object:
dataset_one_normalized <- dataset_one |> normalize()
dataset_two_normalized <- dataset_two |> normalize()

## BMB: I think this does your whole workflow ...
files <- sprintf("synaptic_terminal_data_%s.csv", c("one", "two"))
newdf <- (files
  |> map(read.csv)  ## read both files into a list
  |> map(normalize)
  |> setNames(c("cell1", "cell2"))
  |> bind_rows(.id = "cell")
)
## you could also combine them first and then normalize
## with .by = c(cell, synaptic.terminal.id)

### ACA: For the first plot, I am showing the proportion of synaptic vesicle type for individual synaptic terminals, where the terminals are grouped by cell. This helps to visualize the variability within each cell and between terminals from the same cell. 
### ACA: To follow the Cleveland hierarchy, I decided to use geom_point instead of geom_col to represent my data. In the first plot, each data point represents one synaptic terminal and its corresponding proportion of a synaptic vesicle type.
### ACA: I have decided to use facet_wrap to separate the synaptic terminals from cell one and from cell two.
### ACA: Since most synaptic vesicle types have similar proportions in different synaptic terminals, I have used position_jitter to reduce overlap between datapoints, and I have used kept the gridlines to better distinguish between the x-axis synaptic vesicle types.

ggplot(dataset_all_normalized, aes(synaptic.vesicle.type, proportion, color = synaptic.terminal.id)) +
  geom_point(size = 2,  position = position_jitter(width = 0.2)) +
  facet_wrap(~ cell) +
  labs(x = "Vesicle Type",
       y = "Normalized Proportion per Terminal",
       color = "Terminal ID",
       title = "Proportion of Synaptic Vesicles per Synaptic Terminal in Two Distinct Cells"
       ) +
  ## BMB: if you have a theme you want to use throughout, you can use theme_set() once at the beginning of the session
  theme_linedraw() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1, color = "black"),
        axis.line = element_line(color = "black"),
        axis.text.y = element_text(size = 10, color = "black"))

## BMB: consider splitting x-axis labels with newlines so you don't have to rotate them? (I think there's an extension for this ...)
## (I can appreciate you might not want to flip coordinate axes)

### ACA: I am not too familiar with statistical tests, and I wasn't sure what test to use to compare the proportion of synaptic vesicle type between synaptic terminals and cells. In future plots, I want to compare and check if there are differences in the proportion of synaptic vesicle type per terminal and per cell. I wanted to use a t-test to test the average proportions between the two different cells, but I don't think my data is normally distributed and I'm unsure what non-parametric tests to use.

## BMB: I'd actually probably say a chi-squared test, since want to compare many proportions simultaneously (i.e. you have 4 vesicle types,
## and you want to know if the distribution across all of these types clearly differs -- right?)

cell_means <- dataset_all_normalized |> 
  group_by(cell, synaptic.vesicle.type) |> 
  summarize(mean_proportion = mean(proportion))

### ACA: For the second plot, I am comparing the proportions for each synaptic vesicle type at individual synatic terminals overlaid with the mean proportion for each cell. I plotted the proportion for synaptic vesicle type for individual synaptic terminals and the black data points represent the mean proportion for each vesicle type within each cell. I have kept the grid lines to help distinguish between the x-axis categories.
### ACA: For both plots, I decided to use geom_point since it allows each measurement to be compared using position along a common scale, which is the best way to interpret this data according to the Cleveland hierarchy. The point data also allows for easier visualization of variability between terminals.
pd <- position_dodge(width = 0.2)
ggplot(dataset_all_normalized, aes(synaptic.vesicle.type, proportion, color = cell)) +
  geom_point(size = 2, position = pd) + ##, position = position_jitter(width = 0.2)) +
  geom_point(data = cell_means, aes(y = mean_proportion, group = interaction(synaptic.vesicle.type, cell)), position = pd,
             color = "black", shape = 18,
             size = 6, alpha = 0.6) +
  labs(
    x = "Vesicle Type",
    y = "Vesicle Type Proportion per Terminal",
    title = "Normalized Synaptic Vesicle Composition"
  ) +
  theme_light() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1, color = "black"),
        axis.line = element_line(color = "black"),
        axis.text.y = element_text(size = 10, color = "black"))

## mark: 2.1
