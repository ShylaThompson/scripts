## This script gets you a simple table of all your Wordpress posts. Before you can run this script, you must get the export.xml file
## from Wordpress and save it to your working directory.



## Identify file names of export files
XMLFile_Live <- "Export.xml"

## Parse the xml file and store.
Parse_Live   <- xmlTreeParse(XMLFile_Live, useInternal = TRUE, trim = TRUE)

## scrape the xml files for important values and store in separate tables

Title             <-  xpathSApply(Parse_Live, "//item//title", xmlValue)
Link              <-  xpathSApply(Parse_Live, "//item//link", xmlValue)
Statuse            <-  xpathSApply(Parse_Live, "//item//wp:status", xmlValue)
Author            <-  xpathSApply(Parse_Live, "//item//dc:creator", xmlValue)
Publish_date      <-  xpathSApply(Parse_Live, "//item//pubDate", xmlValue)
Slug              <-  xpathSApply(Parse_Live, "//item//wp:post_name", xmlValue)


## Combine all tables into one table

Data <- cbind(Title, Link, Author, Status, Publish_date, Slug)

## Additional options to further filter your posts to just those that are published

  ##Search within the status text column to find only published topics
  # Search <- grep("publish", Status)
  
  ## Keep only the rows that you want from data table
  # Topics_List <- Data[Search, c(1,2,3,4,5,6)
  
## Write the results to file

FileName <- "Site_posts.csv"
write.csv(Data, FileName, row.names = FALSE)
