

# Load Packages from a List

lshPackages = c('haven', 'labelled', 'stringr', 'stringi', 'dplyr', 'lubridate')

# loop through required packages & if not already installed, load, then install
for(pkg in lshPackages){
  
  if (!require(pkg, character.only = TRUE)){
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}
