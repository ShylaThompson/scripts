## This script is to be used with the html output of the linkchecker 9.3 software. The end result is an Excel file with a table
## that is formatted in a way you can filter which makes it easier to sort through the broken links that were identified.
## You must export the broken link report from the LinkChecker tool in the .html format before you can run this script
## Store the .xml file that you exported in the Working directory

# Load required libraries
library(XML)
library(WriteXLS)

# Load data from LinkChecker output file
Data <- xmlToDataFrame("linkchecker-out.xml", homogeneous = FALSE, collectNames = TRUE)

# Write the table to an Excel file

WriteXLS(Data, ExcelFileName = "BrokenLinkReport.xlsx", row.names = FALSE, col.names = TRUE)
