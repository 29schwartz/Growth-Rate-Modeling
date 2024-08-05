# Growth-Rate-Modeling Repository Overview
This is for taking spark TECAN Data calculating Growth Rates!

Repository includes functions to automatically wrangle **.csv** files from a TECAN Spark plate reader and add important metadata ( _i.e_ plasmid, condition, replicate, _etc._ )! Further you can apply growth rate models to your data using the default growth rate function from [ _Zwietering et al._ ](https://doi.org/10.1128/aem.56.6.1875-1881.1990). You could also manually provide your own! 

The output of the models with give the $\$alpha$, $\lambda$, and $\mu$ coefficients. The derivations for where these come from are described in the aforementioned paper, but in short the $\alpha$ is the horizontal asymptote (max OD), the $\lambda$ is the lag time ( _i.e._ the time it takes for the culture to reach exponential), and the $\mu$ which is equivalent to the growth rate. From the growth rate you can calculate the doubling time! The units for these different model coefficients are OD, hours, and $hours^{-1}$, respectively.

I have example data in the Data folder ( _See Example_Data.csv_ ), an example Metadata file ( _See Metadata.csv_ ) and example script ( _Growth_Rate_Modeling.Rmd_.) Feel free to download the example metadata file and reuse it!

## Running Experiments and Saving Data for script compatibility!

The software provided by the TECAN is fully compatible with the script. However, for each wavelength you measure you **MUST** include the letters "OD" ( _e.g.OD600, OD444_ ) in it's name. TECAN software will auto-label the name of the channel "label 1" by default. This is because the script will parse all channels that have the word OD in it and use this column for plotting!

Also please **make sure to save your data** from the TECAN and metadata always as a _.csv_! Edit your metadata folder appropriately before you start running the script!

Later when wrangling the data, all you will need to do is provide the path of the data folder with your data and the metadata and the script should run smoothly!

Lastly the model fitting will not work with all data. **If you have negative controls that purposely aren't supposed to grow, you must filter them out because the model will not be able to fit a logistic curve to it!**

## Processing Workflow : Organization

### 1 Download Repository
First make sure to download the entire repository. The _Load Packages_ function will install and or load all the necessary packages for this script. **You also won't have to change any of the code in source chunks!**

### 2 Load Data
To load data, all you need to do is provide the path to the directory of the file folder where the directory is in the first code chunk! If you downloaded the repository, it should work automatically! If not you may need to provide the full path.

### 3 Wrangle Data

The [flopR package](https://github.com/ucl-cssb/flopr) was written by Alex J H Fedorec. This package will combine metadata in a very simple format with your complex OD data. You can have whatever you want in the metadata columns, but **the last column must be named well (lowercase) and have the matching wells to your data**.

**The function will parse the metadata and raw data together with the spark_parse function!**

#Plotting Raw Data

Depending on what your goal is I have some code that will allow for plotting the raw data (always important) and finding the maximum OD for each condition. This may be a useful comparison with your data (or maybe not).

## Calculating Experimental Rates

### 1 Nesting Data

If you are unfamiliar with the goal of nesting data I highly recommend checking out [Nested Data](https://tidyr.tidyverse.org/articles/nest.html). In short, it compacts your data by whatever features you nest by and creates a list column that contains data for that specific row. Although this is nice for aesthetic purposes it is incredibly useful for applying models via the map function (similar to the lapply function in base R). You can then apply the specific model across each of the data frames and then using the [tidymodels framework](https://www.tidymodels.org/) and **specifically the broom package you can easily collect model coefficients in a tidy tibble format**, compared to base R which produces an ugly list. 

### 2 Apply Models

Once you nest the data it should be pretty straightforward to calculate model coefficients using the map function! However, it is important to note the model will struggle to fit the data if you include in your data the death phase of the cell culture. Therefore, I usually cut the data off at 15 hours for _E. coli_ to minimize improper fitting. I always wrote code for determining the time of the average OD maximum across conditions and filtering out data that is greater than that time. Up to you! 

### 3 Plotting Coefficients and Model Fits

I then have a few code chunks that plot the model fits and unnest the model coefficients from the nested data frame. This are just example code chunks you may or may not want to use depending on your needs! 

Happy Coding!


