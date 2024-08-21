#These are base packages I always use to run my code!
required_Packages_Install <- c("patchwork",
                               "latex2exp",
                               "splines",
                               "kableExtra",
                               "ggpubr", 
                               "magrittr", 
                               "tidyverse",
                               "roxygen2",
                               "flopr",
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