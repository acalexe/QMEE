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
  geom_point(size = 2,  position = "jitter") +
  facet_wrap(~ cell) +
  labs(x = "Vesicle Type",
       y = "Proportion per Terminal",
       color = "Terminal ID",
       title = "Proportion of Synaptic Vesciles per Synaptic Terminal in Two Distinct Cells"
  ) +
  theme_light() +
  theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 1))
