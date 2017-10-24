## Write intro for script


## Review and clean up this list of libraries. not all are needed.
library(XML)
library(plyr)
library(data.table)
library(dplyr)
library(stringr)
library(rJava)
library(xlsx)


## You must export the .xml file from WordPress before you run this script. 
## Set your working directory to be the same folder where your xml file "lives".

## Identify file name and create empty table
xmlFile  <- "Export.xml"

## Identify the terms that you want to search for.
##IssueTerms <- c("AX 7", "AX7", "Technical Preview", "CTP7", "CTP8", "Rainier", "AX \'7\'")

## Parse the xml file and store.
ParseFile   <- xmlTreeParse(xmlFile, useInternal = TRUE, trim = TRUE)

ParseFile2 <- htmlParse(xmlFile, trim = TRUE)

## scrape the xml file for important values and store in separate tables

Title <-  xpathSApply(ParseFile, "//item//title", xmlValue)
Link <-  xpathSApply(ParseFile, "//item//link", xmlValue)
Text <-  xpathSApply(ParseFile, "//item//content:encoded", xmlValue)
Author <- xpathSApply(ParseFile, "//item/dc:creator", xmlValue)


##This gives all links, not all images.
Href <-   as.data.table(xpathSApply(ParseFile2,"//*[@alt]", xmlAttrs))


##This reverses the columns and headings so that the resulting table only has 5 columns
Peach <- as.data.frame(t(Href))



###write the results to file
FileName    <- "Images.csv" 
write.csv(Peach, FileName, row.names = FALSE, append = FALSE)
