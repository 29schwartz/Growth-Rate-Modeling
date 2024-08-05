# Growth-Rate-Modeling Repository Overview
This is for taking spark TECAN Data calculating Growth Rates!

Repository includes functions to automatically wrangle **.csv** files from a TECAN Spark plate reader! Further you can apply growth rate models to your data using the default growth rate function from [ _Zwietering et al._ ](https://doi.org/10.1128/aem.56.6.1875-1881.1990). You could also manually provide your own! 

The output of the models with give the $\$alpha$, $\lambda$, and $\mu$ coefficients. The derivations for where these come from are described in the aforementioned paper, but in short the $\alpha$ is the horizontal asymptote (max OD), the $\lambda$ is the lag time ( _i.e._ the time it takes for the culture to reach exponential), and the $\mu$ which is equivalent to the growth rate. From the growth rate you can calculate the doubling time! The units for these different model coefficients are OD, hours, and $hours^{-1}$, respectively.

I have example data in the Data folder ( _See Example_Data.csv_ ), an example Metadata file ( _See Metadata.csv_ ) and example script ( _Growth_Rate_Modeling.Rmd_.)

## Running Experiments and Saving Data for script compatibility!

The **logger software** provided by Unisense (found on the computer next to the electrode) is necessary for capturing raw data from your experiment. The software gives options for recording data (play button), stopping recording (stop button), and exporting data. **I highly recommend to create a new folder for each experiment.** Inside the folder you can save all of your trails.

When using the logger software, it is critical you hit the start button before the experimental trail, then following its completion hit the pause button. Then hit export graph to save the data. **You must save the data as a .xlsx**. You should be able to save each trail individually within the folder you created. 

Later when wrangling the data, all you will need to do is provide the path of the folder and the script should run smoothly! **Be aware that if you saved the _logger experiment, a .ulog_ You will need to remove it from the folder. I do not think it serves much purpose outside of when the experiment is actively running. 

**Lastly, name each file with useful information! The file names will end up being split into new columns that give helpful metadata, like the plasmid you used, the dilution, and the replicate** I'll explain more below!

## Processing Workflow : Organization

### 1 Download Repository
First make sure to download the entire repository. The _Load Packages_ function will install and or load all the necessary packages for this script. **You also won't have to change any of the code in source chunks!**

### 2 Load Data
To load data, all you need to do is provide the full path to the directory of the file folder where the directory is in the first code chunk! For me, my data is a folder _29July24_ in the Data folder of the repository! The data can be anywhere however!

### 3 Wrangle Data

The _Sulfide Electrode Data Wrangle_ function will take the first sheet of the .xlsx file (the only one that is important) and first rename the columns to names that are more compatible with R. They will also add a column that is whatever you named your files. The individual files are then read into a list and are named whatever their file name is, besides the .xlsx!

**The function will parse the names of each .xlsx based on _** You can go in to the function and manually change the names of the columns that will be created when the file name is parsed. 

_Example of a file name: SKS015_10X_PC_1 _ I have written the code to split this file name into four different columns: Plasmid, dilution factor, treatment, and replicate, respectively. This is very helpful for later plotting and is necessary for the function to work!

### 4 Cleaning Data

There is an optional chunk that is for if you have any trials that had a large amount of noise (values >600 $\mu$M sulfide) or the trial ran much longer than the rest of the files. You should can visualize what your data looks like with the first ggplot.

## Calculating Experimental Rates

### 1 Nesting Data

If you are unfamiliar with the goal of nesting data I highly recommend checking out [Nested Data](https://tidyr.tidyverse.org/articles/nest.html). In short, it compacts your data by whatever features you nest by and creates a list column that contains data for that specific row. Although this is nice for aesthetic purposes it is incredibly useful for applying models via the map function (similar to the lapply function in base R). You can then apply the specific model across each of the data frames and then using the [tidymodels framework](https://www.tidymodels.org/) and **specifically the broom package you can easily collect model coefficients in a tidy tibble format**, compared to base R which produces an ugly list. 

### 2 Apply Models

Once your data has been nested you will have a column with the time and sulfide concentration. Using the _slope determining_ function, it will calculate the slope for 25 seconds during the linear slope portion of the trial! The code will then organize the model coefficients via the broom package as well as produce a fitted curve to the data. The data can then be easily plotted with the fitted regression line or coefficients can be plotted and shown in a boxplot! You can see example outputs in the Images folder!


