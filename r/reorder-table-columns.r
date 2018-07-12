##Reorder columns in Excel Spreadsheets

library(plyr)
library(data.table)
library(dplyr)
library(stringr)
library(xlsx)

## Get a list of files in working directory
X_files  <- list.files(pattern = "*.xlsx$")

## Apply a function to each file in a list
Data_function <- ldply(seq(X_files), function(i){

  ## read data in a file
  Fields <- read.xlsx(X_files[i], 1)
  
  ## set up new data set with columns ordered as needed. In this example, we move column "2" after Column "4"
  data <- subset(Fields, select=c(1,3,4,2,5,6))
  
  
  ## Get old column names and replace with new column names.
  oldnames <- names(data)
  newnames <- c("Column1", "Column2", "Column3", "Column4", "Column5", "Column6")
  setnames(data, oldnames, newnames)
  
  #  write the file to working directory
  write.xlsx(data, X_files[i], row.names = FALSE)
    
 })


##individual file test to help troubleshoot script

Fields <- as.data.table(read.xlsx("filename.xlsx", 1))

data <- subset(Fields, select=c(6,4,2,1,3,5))
oldnames <- names(data)
newnames <- c("Column1", "Column2", "Column3", "Column4", "Column5", "Column6")
setnames(data, oldnames, newnames)
## This was used to troubleshoot some charcter issues in some of my cell values in a specific column. The next two lines helped clean up that data.
data$Column3 <- as.character(data$Column3)
data$Column3 <- as.character(lapply(data$Column3, str_replace_all, "ÃfÂ¢Ã¢â???sÂ¬Ã¢â,¬Å"", ""))

write.xlsx(data, filename, row.names = FALSE)
