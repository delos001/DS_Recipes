
## Cheat Sheets
|Description|URL|
|---|---|
|RStudio|https://www.rstudio.com/resources/cheatsheets/|
---

## Column Index Custom Function
```
cf_col_num = function(c) {
  column_number = as.data.frame(colnames(c))
  return(column_number)
}
```
---

## Directories, Read, Write
```
Get list of files located in specified path
inps_path = list.files(path = inpt_d, pattern = 'csv', full.names = TRUE)

Read CSV files:
read.csv() 
read.csv(file.path("C:/Users/path/", "filename.csv"), sep=",")
read.csv(file.path(inpt_d, "SV.csv"), 
                    sep = ",", 
                    skip = 3,
                    header = TRUE)

Write CSV:
write.csv(mydata, file.path("C:/Users/path/", "filename.csv")) 

Read Table:
read.table() 
read.table("filename.txt", header=T, na.strings="?")


Write Table:
write.table(mydata, "filename.csv") 
write.table(mydata, 
            file.path("C:/Users/path/", "filename.csv"),
            row.names=FALSE) 
```


## Other:
```
Call another R script
source("some_script.R")         # In this directory
source("../another_script.R")   # In the parent directory
source("folder/stuff.R")        # In a child directory

Document Session Info:
sess = sessionInfo()
toLatex(sess)
```
---

## Basic R-Studio Commands
|Syntax|Desription|
|---|---|
|library()|show packages found in library|
|library(packagename)|load a package into your library|
|require(packagename)|similar to 'library' but gives true/false output if package there or not|
|help(function)|opens help for function of interest|
|---|---|
|data()|provides list of standard data sests available|
|data('name')|loads data set of interest|
|---|---|
|setwd(path)|change working directory to specified path|
|getwd()|print current working directory|
|---|---|
|ls()|list objects in current workspace|
|rm(x,y)|remove specified objects|
|rm(list = ls())|remove all objects in current workspace|
|---|---|
|save.image("mywork.Rdata")|save the workspace to the file .RData in the cwd|
|save(object list,file="mywork.RData")|save specific objects, if you don't specify the path, the cwd is assumed|
|savehistory()|save record of all the commands typed in current session|
|loadhistory()|load a workspace into the current session.  if you don't specify the path, the cwd is assumed|
---

## Logical Operators
|Operator|Desription|
|---|---|
|==|equal to|
|!=|not equal to|
| >|great than|
| <|less than|
|>=|greater than or equal to|
|<=|less than or equal to|
|x%%y|modular division, return remainder|
|!x|not x|
|x|y|x or y|
|x&y|x and y|



