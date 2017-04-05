library(dplyr)
library(tidyr)
library(openxlsx)

setwd("S:/Projects/DLM Dropbox/TIP pages/TIP workgroup - copies only")

filename <- "ELA 01112017 a.xlsx"
TIPs_file <- read.xlsx(filename)

subject <- NULL
if(grepl("^ELA", filename, ignore.case = FALSE)){
  subject <- "ELA"
} else if(grepl("^M", filename) | grepl("^Math", filename, ignore.case = FALSE)){
  subject <- "M"
} else if(grepl("^Sci", filename , ignore.case = FALSE)){
  subject <- "SCI"
}
  
if(subject == "ELA"){
  TIPs_file$`Exclude.Support:.Translation` <- gsub("FALSE", 
                                                   "Follow your state's guidance on the use of language translation.", 
                                                   TIPs_file$`Exclude.Support:.Translation`)
  TIPs_file$`Exclude.Support:.Translation` <- gsub("TRUE", 
                                                   "Do not translate words for the student.", 
                                                   TIPs_file$`Exclude.Support:.Translation`)
  
  TIPs_file$`Exclude.Support:.Definition` <- gsub("FALSE", 
                                                   NA, 
                                                   TIPs_file$`Exclude.Support:.Definition`)
  TIPs_file$`Exclude.Support:.Definition` <- gsub("TRUE", 
                                                  "Do not define words for the student.", 
                                                  TIPs_file$`Exclude.Support:.Definition`)
} else if(subject == "M"){
  for(i in 1:nrow())
  
} else if(subject == "SCI"){
  
}


if(`Exclude.Support:.Definitions` == FALSE & `Exclude.Support:.Translation` == FALSE){
  `Exclude.Support:.Translation` <- "None"
  `Exclude.Support:.Definitions` <- NA
}