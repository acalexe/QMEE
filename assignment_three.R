library(tidyverse)
library(ggplot2)
library(patchwork)

dataset_one <- read.csv("synaptic_terminal_data_one.csv")

dataset_two <- read.csv("synaptic_terminal_data_two.csv")

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
  

cell_one <- ggplot(dataset_one_normalized, aes(synaptic.terminal.id, proportion, fill = synaptic.vesicle.type)) +
  geom_col(position = "dodge") +
  labs(
    x = "synaptic terminal id",
    y = "vesicle type proportion",
    fill = "vesicle type"
  ) +
  theme_classic()

cell_two <- ggplot(dataset_two_normalized, aes(synaptic.terminal.id, proportion, fill = synaptic.vesicle.type)) +
  geom_col(position = "dodge") +
  labs(
    x = "synaptic terminal id",
    y = "vesicle type proportion",
    fill = "vesicle type"
  ) +
  theme_classic()

cell_one + cell_two
         