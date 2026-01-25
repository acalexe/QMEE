library(tidyverse)
library(ggplot2)

### ACA: insert text.

dataset_one <- read.csv("synaptic_terminal_data_one.csv")

dataset_two <- read.csv("synaptic_terminal_data_two.csv")

### ACA: insert text. Normalize vesicle type data within each synaptic terminal.

dataset_one_normalized <- dataset_one |> 
  group_by(synaptic.terminal.id) |> 
  mutate(total_vesicles = sum(count),
         proportion = count / total_vesicles) |> 
  ungroup()


dataset_two_normalized <- dataset_two |> 
  group_by(synaptic.terminal.id) |> 
  mutate(total_vesicles = sum(count),
         proportion = count / total_vesicles) |> 
  ungroup()

### ACA: combining the two datasets into one data frame.
### ACA: I used bind_rows(). Not sure if there is a better option.

dataset_all_normalized <-  bind_rows(
  dataset_one_normalized |> mutate(cell = "cell 1"),
  dataset_two_normalized |> mutate(cell = "cell 2")
)

ggplot(dataset_all_normalized, aes(synaptic.vesicle.type, proportion, color = synaptic.terminal.id)) +
  geom_point(size = 2,  position = position_jitter(width = 0.2)) +
  facet_wrap(~ cell) +
  labs(x = "Vesicle Type",
       y = "Proportion per Terminal",
       color = "Terminal ID",
       title = "Proportion of Synaptic Vesciles per Synaptic Terminal in Two Distinct Cells"
  ) +
  theme_light() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1))


### ACA: I am not too familiar with statistical tests, and I wasn't sure what test to use to compare the proportion of synaptic vesicle type between synaptic terminals and cells.

### ACA: I want to compare and check if there are differences in the proportion of synaptic vesicle type per cell. I wanted to use a t-test to test the average proportions between the two different cells, but I don't think my data is normally distributed and I'm unsure what non-parametric tests to use.

cell_means <- dataset_all_normalized |> 
  group_by(cell, synaptic.vesicle.type) |> 
  summarize(mean_proportion = mean(proportion))

### ACA: individual terminal data and individual cell data.
ggplot(dataset_all_normalized, aes(synaptic.vesicle.type, proportion, color = cell)) +
  geom_point(size = 2, position = position_jitter(width = 0.2)) +
  geom_point(data = cell_means, aes(y = mean_proportion)) +
  labs(
    x = "Vesicle Type",
    y = "Vesicle Type Proportion per Terminal",
    title = "Overall Synaptic Vesicle Composition"
  ) +
  theme_light() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1))


  
