### This script runs against a GitHub repo and generates one word document from all the markdown files in the repo. It uses a toc.md file to get the order in which the markdown files should be "written" to the word doc.

# 1. Run this portion first.
setwd("[set WD to be where your repo is locally]")

library(knitr)
library(png)
library(rmarkdown)
library(dplyr)
library(plyr)
library(reshape2)
library(tidyr)
library(tibble)
library(stringr)
library(WriteXLS)
library(gsubfn)


## Get list of topics
Files <- list.files(path = ".", pattern = "*\\.md$", full.names = TRUE, recursive = TRUE, all.files = TRUE)

## Get list of image files
ImageFiles <- list.files(path = ".", pattern = "*\\.png$|*\\.jpg$", full.names = TRUE, recursive = TRUE, all.files = TRUE)


## Sub function for replacing string pattern matches. 
### This code chunk found on Stackoverflow, submitted by Theodore Lytras. https://stackoverflow.com/questions/15253954/replace-multiple-letters-with-accents-with-gsub

subswitch <- function(pattern, replacement, x, ...) {
if (length(pattern)!=length(replacement)) {
  stop("pattern and replacement do not have the same length.")
}
result <- x
for (i in 1:length(pattern)) {
  result <- gsub(pattern[i], replacement[i], result, ...)
}
result
}


## Identify TOC file
### If TOC file is not located at root of WD, change path.
TOC <- "toc.md"
TOCOrder <- readLines(TOC)

  ### Get only the path information for the topics from the TOC file
  TopicOrder <-  str_extract(TOCOrder, '\\(([^\\)]+)\\)')

  ### Remove parenthesis characters from list
  TopicOrder <- gsub("\\(", "", TopicOrder)
  TopicOrder <- gsub("\\)", "", TopicOrder)

  ### Keep only items with ".md" in the path.
  TopicOrderMDFiles <- grepl("*\\.md$", TopicOrder)
  TopicOrder <- TopicOrder[TopicOrderMDFiles]
  TopicOrder <- na.omit(TopicOrder)


## Generate RMD file


book_header = readLines(textConnection("---\ntitle: 'Title'\noutput:\nword_document:\nreference_docx: template.docx\n---"))

  write(book_header, file = "Doc.Rmd")
  cfiles <- TopicOrder
  text <- NULL
  Subs <- data.frame(NA, NA, stringsAsFactors = FALSE)
  names(Subs) <- c("ImageName", "Path")
  for(i in 1:length(cfiles)){
    text <- readLines(cfiles[i], encoding = "UTF-8")
    hspan <- grep("---", text)
    text <- text[-c(hspan[1]:hspan[2])]
    
    
    FindImages <- grepl("\\!\\[", text)
    
    if (sum(FindImages) > 0){

    ImageLines <- text[FindImages]
    #SubstituteImageText <- data.frame(NA,NA)
    #names(SubstituteImageText) <- c("Line", "newLine")
    
    Subs <- ldply(seq(ImageLines), function(j){
      
      Line <- ImageLines[j]
      ImageName <- str_extract(Line, "\\bmedia\\S*" )
      ImageName <- gsub(")", "", ImageName)
      
      LineMatch <- grepl(ImageName, ImageFiles)
      
      Path <- ImageFiles[LineMatch]
      
      #newLine <- paste("include_graphics('", Path, "')", sep = "")
      
      Subs <- data.frame(ImageName, Path)
      
    })
    
   ### replace image paths with relative paths to root
    text <- subswitch(Subs$ImageName, Subs$Path, text, fixed = TRUE)
   ### Replace all banners with empty text 
  
    }
    text <- gsub("^\\[\\!.*", "", text, fixed = FALSE)
    text <- gsub("^>\\[\\!.*", "", text, fixed = FALSE)
    write(text, sep = "\n", file = "Doc.Rmd", append = T)
  }
  
  ### 2. Run this portion last to render the final word document.
  render("Doc.Rmd", output_format = "word_document")





######################Test On One File or troubleshooting purposes#####################################

# This code is for troubleshooting code using only one .md file.
# 
# 
# 
# ## replace image reference with knitr reference
# 
# ImageFiles <- list.files(path = ".", pattern = "*\\.png$|*\\.jpg$", full.names = TRUE, recursive = TRUE, all.files = TRUE)
# 
# ## Find lines with images test with one file
# 
# 
# Testfile <- "test.md"
# 
# 
# ## Sub function for replacing string pattern matches
# subswitch <- function(pattern, replacement, x, ...) {
#   if (length(pattern)!=length(replacement)) {
#     stop("pattern and replacement do not have the same length.")
#   }
#   result <- x
#   for (i in 1:length(pattern)) {
#     result <- gsub(pattern[i], replacement[i], result, ...)
#   }
#   result
# }
# 
# 
# 
# 
# 
# 
# 
# ## Generate RMD file
# 
# book_header = readLines(textConnection("---\ntitle: 'Title'\n---"))
#   write(book_header, file = "Doc.Rmd")
#   cfiles <- TopicOrder
#   text <- NULL
#   Subs <- data.frame(NA, NA, stringsAsFactors = FALSE)
#   names(Subs) <- c("ImageName", "Path")
#   
#     text <- readLines(Testfile, encoding = "UTF-8")
#     hspan <- grep("---", text)
#     text <- text[-c(hspan[1]:hspan[2])]
#     
#     
#     FindImages <- grepl("\\!\\[", text)
#     
#     if (sum(FindImages) > 0){
#       
#       ImageLines <- text[FindImages]
#       #SubstituteImageText <- data.frame(NA,NA)
#       #names(SubstituteImageText) <- c("Line", "newLine")
#       
#       Subs <- ldply(seq(ImageLines), function(j){
#         
#         Line <- ImageLines[j]
#         ImageName <- str_extract(Line, "\\bmedia\\S*" )
#         ImageName <- gsub(")", "", ImageName)
#         
#         LineMatch <- grepl(ImageName, ImageFiles)
#         
#         Path <- ImageFiles[LineMatch]
#         
#         #newLine <- paste("include_graphics('", Path, "')", sep = "")
#         
#         Subs <- data.frame(ImageName, Path)
#         
#       })
#       
#       ### replace image paths with relative paths to root
#       text <- subswitch(Subs$ImageName, Subs$Path, text, fixed = TRUE)
#       ### Replace all banners with empty text 
#       text <- gsub("^\\[\\!.*", "", text, fixed = FALSE)
#     }
#     
#     write(text, sep = "\n", file = "Doc.Rmd", append = T)
#   
#   render("Doc.Rmd", output_format = "word_document")
#   setwd(old)
# 
# 
# Generate_Doc()
# 
# 
# 
