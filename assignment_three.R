library(tidyverse)
library(ggplot2)
library(patchwork)

dataset_one <- read.csv("synaptic_terminal_data_one.csv")

dataset_two <- read.csv("synaptic_terminal_data_two.csv")

dataset_one_normalized <- dataset_one |> 
  group_by(synaptic.terminal.id) |> 
  mutate(total_vesicles = sum(count),
         proportion = count / total_vesicles)

dataset_two_normalized <- dataset_two |> 
  group_by(synaptic.terminal.id) |> 
  mutate(total_vesicles = sum(count),
         proportion = count / total_vesicles)