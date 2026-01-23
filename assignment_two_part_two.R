clean_data <- readRDS("cleaned_vesicle_fwhm_data.rds")

library(tidyverse)

## The tidy, grammar-of-graphics way to plot these two things as different shapes would be to pivot_longer to put them in the same column (and represent that they are comparable)
ggplot(clean_data, aes(x = vesicle_id)) +
  geom_point(aes(y = x), color = "red", shape = "triangle") +
  geom_point(aes(y = y), color = "blue", shape = "square") +
  labs( x= "synaptic vesicle ID",
        y = "fwhm (microns)",
        title = "X- and Y-axis full-width values at half-maximum intensity for individual synaptic vesicles") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) 

#### ACA: Now RStudio treats the vesicle_id column as a factor. Unsure what to do so that the x-axis values do not overlap... I just removed the x-axis text to prevent this issue.
## JD: You could have a numeric version just for plotting if it would be useful to help keep track of things; another question would be whether this is a useful way of plotting these data since the numbers don't seem to have much to do with much


mean_x_fwhm <- clean_data |> 
  summarize(mean_x_fwhm = mean(x))

mean_y_fwhm <- clean_data |> 
  summarize(mean_y_fwhm = mean(y))

print(mean_x_fwhm)
print(mean_y_fwhm)

### ACA: For the synaptic vesicle population data, the mean fwhm values for the x- and y- axes are approximately equal, in line with the fact that synaptic vesicles are spherical (for the most part, they are slightly ellipsoidal depending on the synaptic vesicle type).




