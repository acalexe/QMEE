library(tidyverse)
library(palmerpenguins)

penguins |> 
  group_by(island,species) |> 
  summarize(
    mean_body_mass_g = mean(body_mass_g, na.rm = TRUE),
    SE = sd(body_mass_g, na.rm = TRUE)/sqrt(n())
  ) |> 
  ggplot(aes(x = species, y = mean_body_mass_g, fill = island)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = mean_body_mass_g - SE, ymax = mean_body_mass_g + SE),
                position = "dodge") +
  labs(
    title = "Mean Penguin Weight by Species",
    x = "Species",
    y = "Weight (grams)"
  ) + theme_minimal()


