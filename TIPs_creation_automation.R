################################################################################
# This script automates the TIPs PDF preparation process
################################################################################
# The program works by taking the QCed data files from Rally, then:
# 1. Edit values according to subject
# 2. Edit values according to BR/BVI
# 3. Inserts values into LaTeX code
# 4. Uses LaTeX code to output PDFs
################################################################################
# Code written/adapted April 6, 2017 by Jennifer Brussow 
################################################################################

################################################################################
# TO DO LIST ###################################################################
################################################################################
# - fix LaTeX code
# - add checks to ensure column names come out as expected
# - add Rally extract QC process (may be separate program?)
################################################################################

library(dplyr)
library(tidyr)
library(openxlsx)

work_dir <- "S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/"
setwd(work_dir)

filename <- "S:/Projects/DLM Dropbox/TIP pages/TIP workgroup - copies only/ELA 01112017 a.xlsx"
TIPs_file <- read.xlsx(filename)
filename <- unlist(strsplit(filename, split = "/"))
filename <- filename[length(filename)]

new_names <- make.names(names(TIPs_file))
new_names <- gsub("\\.\\.", "\\.", new_names)
new_names <- gsub("\\.\\.", "\\.", new_names)
new_names <- gsub("\\.$", "", new_names)

names(TIPs_file) <- new_names

subject <- NULL
if(grepl("^ELA", filename, ignore.case = FALSE)){
  subject <- "ELA"
} else if(grepl("^M", filename) | grepl("^Math", filename, ignore.case = FALSE)){
  subject <- "M"
} else if(grepl("^Sci", filename , ignore.case = FALSE)){
  subject <- "SCI"
}

extra <- ""
if(grepl("BR", filename)){
  extra <- "BR"
} else if(grepl("BVI", filename)){
  extra <- "BVI"
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

if(extra == "BR"){
  TIPs_file$B.VI <- "BR"
} else {
  TIPs_file$B.VI <- gsub("TRUE", "BVI", TIPs_file$B.VI)
  TIPs_file$B.VI <- gsub("FALSE", NA, TIPs_file$B.VI)
}

TIPs_file$filename <- paste0(subject, TIPs_file$Form, extra)

for(file in 1:nrow(TIPs_file)){
  rmarkdown::render('S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/TIPS Template test.Rmd',  
                    output_file =  paste0(TIPs_file[file, "filename"],".pdf"), 
                    output_dir = 'S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/reports')
}


saveRDS(TIPs_file, "test_TIPs_file.rds")



