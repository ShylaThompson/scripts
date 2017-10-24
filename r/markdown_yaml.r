
## This script gets you a report of all YAML data for all .md files in a GitHub repo. Before you can run this script, you must clone
## your repo locally and set your repo root to be your working directory.

library(rmarkdown)
library(dplyr)
library(plyr)
library(reshape2)
library(tidyr)
library(tibble)


files <- list.files(path = ".", pattern = "*.md", full.names = TRUE, recursive = TRUE, all.files = TRUE)
fileNum <- length(files)

## Note that this data frame should just have enough variables for the YAML info you want to capture.
df <- data.frame(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA, stringsAsFactors = FALSE)
df[1,] <-as.character(df[1,])
## Note the character vector below is made up of unique YAML strings for my repo. You'll want to change this to the YAML info you care about.
df_names <- c("path", "title", "description","author","manager","ms.date","ms.topic","ms.service","audience","ms.search.scope","ms.custom","ms.assetid","ms.search.region","ms.author","ms.search.validFrom", "ms.dyn365.ops.version")
names(df) <- df_names
table <- data.frame()

GetParams <- ldply(seq(1:fileNum[1]), function(i){
#GetParams <- ldply(seq(1:10), function(i){
    
Parameters <- unlist(rmarkdown::yaml_front_matter(files[i], encoding = getOption("encoding")))
Parameters <- as.data.frame(Parameters)
Parameters <- rownames_to_column(Parameters, "Metadata")
PathVector <- data.frame("path", files[i])
names(PathVector) <- names(Parameters)
Parameters <- rbind(as.data.frame(PathVector), Parameters)
table <- as.data.frame(t(Parameters))
colnames(table) <- as.character(unlist(table[1,]))
table <- table[-1,]
table <- as.data.frame(table)
rbind.fill(df, table)
})

MetaData <- GetParams[!GetParams$path == "NA",]

write.csv(MetaData, "MetaData.csv", row.names = FALSE)





### Single File test
Parameters <- unlist(rmarkdown::yaml_front_matter(files[4], encoding = getOption("encoding")))
## add topic path to data
Parameters <- as.data.frame(Parameters, stringsAsFactor = FALSE)
## make row names into a column of data.
Parameters <- add_rownames(Parameters, "Metadata")
PathVector <- data.frame("path", files[1])
names(PathVector) <- names(Parameters)
Parameters <- rbind(as.data.frame(PathVector), Parameters)
table <- as.data.frame(t(Parameters))
colnames(table) <- as.character(unlist(table[1,]))
table <- table[-1,]

df_new <- spread(Parameters, Metadata, Parameters, fill = NA, convert = TRUE)

MyDATA <- rbind.fill(df,table)

