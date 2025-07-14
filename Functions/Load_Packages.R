#These are base packages I always use to run my code!
required_Packages_Install <- c("devtools",
                               "patchwork",
                               "latex2exp",
                               "splines",
                               "kableExtra",
                               "ggpubr", 
                               "magrittr", 
                               "tidyverse",
                               "roxygen2",
                               "tidymodels",
                               "ggstatsplot",
                               "ggthemes",
                               "DescTools")

#If you already have the packages 
#This code will avoid reinstalling the packages!
for(Package in required_Packages_Install){
  if(!require(Package,character.only = TRUE)) { 
    install.packages(Package, dependencies=TRUE)
  }
  library(Package,character.only = TRUE)
}


if("flopr" %in% installed.packages()[,"Package"] == FALSE) {
  devtools::install_github("ucl-cssb/flopr") 
} else {
  library(flopr)
  print("flopR installed and loaded")
}

