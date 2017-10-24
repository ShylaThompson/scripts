## This script identifies markdown files in a GitHub repo that are not linked to from a TOC file in that same repo.
## This script depends on a specific folder structure for the repo, but can be modified to work for other structures
## You must clone your repo locally and then set the root of the repo as your working directy to run this script

## Load required library in R
library(plyr)


## Get list of files and paths
filepath <- list.files(path = ".", pattern = "md$", recursive = TRUE)
filename <- basename(filepath)
filename_sans_md <- gsub(".md", "", filename, fixed = FALSE)


## Get TOC file
TOC <- readLines("./core/TOC.md",ok = TRUE, warn = FALSE, skipNul = TRUE)

## Create data.frame

DF <- data.frame(NA,NA,NA, stringsAsFactors = FALSE)
colnames(DF) <- c("File name", "Path", "Found in TOC")

## Search TOC file for missed .md references

Search <- ldply(seq(filename_sans_md), function(i){
  
  Search <- grep(filename_sans_md[i],TOC, fixed = TRUE)
  if (length(Search) > 0) {
    Result <- data.frame(filename_sans_md[i],filepath[i],"Yes")
    colnames(Result) <- c("File name", "Path", "Found in TOC")
    DF <- rbind(DF, Result)
  }
  else {
    Result <- data.frame(filename[i],filepath[i],"No")
    colnames(Result) <- c("File name", "Path", "Found in TOC")
    DF <- rbind(DF, Result)
  }
})

# ABC <- test %>% group_by(Path, Found) %>% summarize(count = n())
## Revisit this section and fix
# Results <- ABC[ABC$count ==1300,]

Results <- na.omit(Search)
write.csv(Results, "Not_in_TOC.csv", row.names = FALSE)



## Search .md topics for references to media files, if found return Yes in table of list of media files, if no return no in table of media files
# create data frame for report content
DF <- data.frame(NA,NA,NA,NA, stringsAsFactors = FALSE)
colnames(DF) <- c("Media_File", "Path", "Found", "Topic")


## find files that include the string and note file line where the string is found


SearchTopics <- ldply(Topics, function(j){
  
  x <- readLines(j, ok = TRUE, warn = FALSE, skipNul = TRUE)
  y <- Topics[j]
  Lines <- ldply(seq(filename), function(i){
    
    Search <- grep(filename[i],x, fixed = TRUE)
    if (length(Search) > 0) {
      Result <- data.frame(filename[i],filepath[i],"Yes", y)
      colnames(Result) <- c("Media_File", "Path", "Found", "Topic")
      DF <- rbind(DF, Result)
    }
    else {
      Result <- data.frame(filename[i],filepath[i],"No", NA)
      colnames(Result) <- c("Media_File", "Path", "Found", "Topic")
      DF <- rbind(DF, Result)
    }
  })
})

SearchTopics <- SearchTopics[SearchTopics$Found %in% c("No", "Yes"),]
SearchTopics$Path <- as.factor(SearchTopics$Path)
SearchTopics$Topic <- as.factor(SearchTopics$Topic)
SearchTopics$Media_File <- as.factor(SearchTopics$Media_File)
SearchTopics$Found <- as.factor(SearchTopics$Found)

#identify the not referenced media

ABC <- test %>% group_by(Path, Found) %>% summarize(count = n())
## Revisit this section and fix 
Results <- ABC[ABC$count ==1300,]

write.csv(Results, "Media_Not_Referenced.csv", row.names = FALSE)
