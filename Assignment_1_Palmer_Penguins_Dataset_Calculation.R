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

# The mean weight data shows that the Gentoo penguin species is the heaviest species out of the three penguin species. Furthermore, the mean weight data shows that for a penguin species found on multiple islands, such as Adelie and Chinstrap, the mean species weight does not differ based on the island location.


