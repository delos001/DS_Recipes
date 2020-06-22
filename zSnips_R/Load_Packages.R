

# Load Packages from a List

lpkgs = c('haven', 'labelled', 'stringr', 'stringi', 'dplyr', 'lubridate')

# loop through required packages & if not already installed, load, then install
for(pkg in lpkgs){
  
  if (!require(pkg, character.only = TRUE)){
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}
