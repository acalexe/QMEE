# QMEE

Repository for Biology 708: Quantitative Methods in Ecology and Evolution

Assignment One:

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

Assignment Two:

The relative working directory for assignment 2 is QMEE/assignment_two_part_one.R and QMEE/assignment_two_part_two.R. 

Assignment two is located in the QMEE repo directory. The relative working directory for assignment 2 is ‘QMEE/assignment_two_part_one.R’. There are two RStudio scripts for assignment two. The first is ‘assignment_two_part_one.R’, which loads in the ‘Blue Gel1_Cell2 Deconvolved Data.xlsx’ Excel file. The script that extracts the data from the Excel file was written by Dr. Bolker, and it outputs a tibble that contains three columns. One column is for either x- and y-axis coordinates for individual synaptic vesicles, the second column represents the synaptic vesicle id number and the third column represents the full-width at half-maximum intensity distance (microns) for the each synaptic vesicle axis (x- or y-axis). 

For the first part of the assignment, I first clean up the data by organizing the x- and y- axis values coordinates in increasing order with the corresponding synaptic vesicle id. 

Here, the x- and y-axis values are both in the same column, but ideally they should be individual columns that pertain to a specific synaptic vesicle id. To fix this, I pivot the data so that each row represents one vesicle id with its corresponding x- and y-axis fwhm values. 

Next, I check to see what R structures of the data frame is and if there are any anomalies. Here, RStudio shows that the vesicle id column is a numeric column, but it should be a factor since the vesicle ids are separate entities. I fix this by changing the column from a numeric to a factor column. 

Lastly, I check to see if there are any duplicate data points in my data frame.



The second part of the assignment is named ‘assignment_two_part_two.R’ and it reads the .RDS file created from assignment one that contains the cleaned data. This assignment plots the x- and y-axis fwhm size for each individual synaptic vesicle on the same graph. It also calculates the mean fwhm size for the x- and y-axis. Here, the two mean values are similar in size, which is consistent to empirical data of synaptic vesicles being spherical / slightly ellipsoidal.


In the end, I would like to determine if bright clusters in my microscopy images correspond to individual synaptic vesicles. One way to test this is to label synaptic vesicles with two probes of different sizes. If our bright clusters of label corresponded to individual synaptic vesicles, labeling one set of vesicles with a large label and another set with a small label would result in two distributions of apparent vesicle size. We quantify vesicle size by measuring the full width at half maximum intensity (FWHM) of individual synaptic vesicles in the X and Y dimensions. I find the highest intensity value by looking at multiple optical sections of a synaptic vesicle and I find the image pixel  with the highest intensity, which should represent the centre of a synaptic vesicle. The maximum intensity value is an arbitrary unit (based on the bit-depth of camera / microscope). Based on the maximum intensity, I calculate the full-width distance of each synaptic vesicle in both the x- and y-axis for values that are above half-maximum intensity.

I am blind which dataset contains either the small or large label size. For this assignment, I have only included one of the datasets to clean the data, but I am hoping to use both datasets for future assignments to compare apparent synaptic vesicle sizes. 

