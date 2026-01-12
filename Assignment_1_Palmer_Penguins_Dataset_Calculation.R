library(tidyverse)
#library(palmerpenguins)

penguins <- read.csv("penguins.csv", header = TRUE)

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

## BMB: "does not differ" is *wrong* (wait for lectures on significance testing/clarity)

## BMB: this does your summarization a bit more compactly

se_fun <- \(x) { sd(x, na.rm=TRUE)/sqrt(length(na.omit(x))) }

p2 <- penguins |> 
    summarize(
        across(body_mass_g,
               .fns = list(mean=\(x) mean(x, na.rm = TRUE),
                           se = se_fun)),
        .by = c(island, species)
    )

## BMB: in this case it's easier to see differences without including zero mass
## as a baseline
ggplot(p2, aes(x = species, y = body_mass_g_mean, colour = island)) +
    geom_pointrange(aes(ymin = body_mass_g_mean - body_mass_g_se,
                        ymax = body_mass_g_mean + body_mass_g_se),
                    position = position_dodge(width = 0.5))
## BMB: converting from g to kg might also be good for dataviz

## BMB: this is fine, although a tiny bit superficial - 1.9
