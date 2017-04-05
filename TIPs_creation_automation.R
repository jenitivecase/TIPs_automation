library(dplyr)
library(tidyr)
library(openxlsx)

setwd("S:/Projects/DLM Dropbox/TIP pages/TIP workgroup - copies only")

filename <- "ELA 01112017 a.xlsx"
TIPs_file <- read.xlsx(filename)

new_names <- make.names(names(TIPs_file))
new_names <- gsub("\\.\\.", "\\.", new_names)
new_names <- gsub("\\.\\.", "\\.", new_names)

names(TIPs_file) <- new_names

subject <- NULL
if(grepl("^ELA", filename, ignore.case = FALSE)){
  subject <- "ELA"
} else if(grepl("^M", filename) | grepl("^Math", filename, ignore.case = FALSE)){
  subject <- "M"
} else if(grepl("^Sci", filename , ignore.case = FALSE)){
  subject <- "SCI"
}
  
if(subject == "ELA"){
  TIPs_file$Exclude.Support.Translation <- gsub("FALSE", 
                                                   "Follow your state's guidance on the use of language translation.", 
                                                   TIPs_file$Exclude.Support.Translation)
  TIPs_file$Exclude.Support.Translation <- gsub("TRUE", 
                                                   "Do not translate words for the student.", 
                                                   TIPs_file$Exclude.Support.Translation)
  
  TIPs_file$Exclude.Support.Definitions <- gsub("FALSE", 
                                                   NA, 
                                                   TIPs_file$Exclude.Support.Definitions)
  TIPs_file$Exclude.Support.Definitions <- gsub("TRUE", 
                                                  "Do not define words for the student.", 
                                                  TIPs_file$Exclude.Support.Definitions)
} else if(subject == "M"){
  for(i in 1:nrow(TIPs_file)){
    if(TIPs_file[i, Exclude.Support.Definitions] == FALSE & TIPs_file[i, Exclude.Support.Translation] == FALSE){
      TIPs_file[i, Exclude.Support.Translation] <- "None"
      TIPs_file[i, Exclude.Support.Definitions] <- NA
    } else {
      ifelse(TIPs_file[i, Exclude.Support.Definitions] == FALSE,
             TIPs_file[i, Exclude.Support.Definitions] <- NA,
             TIPs_file[i, Exclude.Support.Definitions] <- "Definitions (see \"other comments\")")
      ifelse(TIPs_file[i, Exclude.Support.Translation] == FALSE,
             TIPs_file[i, Exclude.Support.Translation] <- NA,
             TIPs_file[i, Exclude.Support.Translation] <- "Do not translate words for this student.")
      
    }
  }
  
} else if(subject == "SCI"){
  TIPs_file$Exclude.Support.Translation <- gsub("FALSE", 
                                                "Follow your state's guidance on the use of language translation.", 
                                                TIPs_file$Exclude.Support.Translation)
  TIPs_file$Exclude.Support.Translation <- gsub("TRUE", 
                                                "Do not translate words for the student.", 
                                                TIPs_file$Exclude.Support.Translation)
  
  TIPs_file$Exclude.Support.Definitions <- gsub("FALSE", 
                                                NA, 
                                                TIPs_file$Exclude.Support.Definitions)
  TIPs_file$Exclude.Support.Definitions <- gsub("TRUE", 
                                                "Definitions (see \"other comments\")", 
                                                TIPs_file$Exclude.Support.Definitions)
}


