clean_data <- readRDS("cleaned_vesicle_fwhm_data.rds")

library(tidyverse)

### ACA: check for any duplicated data points.
sum(duplicated(clean_data))

ggplot(clean_data, aes(x = vesicle_id)) +
  geom_point(aes(y = x), color = "red", shape = "triangle") +
  geom_point(aes(y = y), color = "blue", shape = "square") +
  labs( x= "synaptic vesicle ID",
        y = "fwhm (microns)",
        title = "X- and Y-axis full-width values at half-maximum intensity for individual synaptic vesicles") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) 

#### ACA: Now RStudio treats the vesicle_id column as a factor. Unsure what to do so that the x-axis values do not overlap... I just removed the x-axis text to prevent this issue.


mean_x_fwhm <- clean_data |> 
  summarize(mean_x_fwhm = mean(x))

mean_y_fwhm <- clean_data |> 
  summarize(mean_y_fwhm = mean(y))

print(mean_x_fwhm)
print(mean_y_fwhm)

### ACA: For the synaptic vesicle population data, the mean fwhm values for the x- and y- axes are approximately equal, in line with the fact that synaptic vesicles are spherical (for the most part, they are slightly ellipsoidal depending on the synaptic vesicle type).




