# QMEE

Repository for Biology 708: Quantitative Methods in Ecology and Evolution

For the first assignment, I chose to use the palmerpenguins data package (https://allisonhorst.github.io/palmerpenguins/). The package contains the 'penguins' dataset which contains size measurements for various parameters from three different penguin species located in three different islands. For the first assignment, I want to compare the mean body mass for each penguin species based on the corresponding island that they are located in, along with the corresponding standard error. A second purpose of this calculation is to determine if the mean weight of a penguin species that is found on multiple islands differs based on the location. To calculate this, I grouped the penguins based on their corresponding species and based on the island they occupy.

BMB: It's fine to use the penguins for the first assignment. For the second assignment, which will involve data *cleaning*, a pre-cleaned/tidied data set is suboptimal ...

BMB: (1) "whether the mean weight differs" is incorrect (the mean weight will certainly differ; you're interested in statistically, but primarily *biologically* significant differences. (2) We're hoping that you will quickly get to scientific questions that are interesting to you, so that you can work on translating them to statistical questions/workflows ...

The main file to look at is "Assignment_1_Palmer_Penguins_Dataset_Calculation"

```
read.csv("penguins.csv")
```

The working directory for this assignment is "/Users/andreialexe/Desktop/QMEE"

BMB: actually the working directory is "the head directory of the repository"; other people may have the repository cloned to different places (on my computer this directory is `/home/bolker/classes/QMEE/private/student_repos/acalexe`)

```
citation("palmerpenguins")
#
#> To cite palmerpenguins in publications use:
 
Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/. doi: 10.5281/zenodo.3960218.
```
