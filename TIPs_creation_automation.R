################################################################################
# This script automates the TIPs PDF preparation process
################################################################################
# The program works by taking the QCed data files from Rally, then:
# 1. Edit values according to subject
# 2. Edit values according to BR/BVI
# 3. Inserts values into LaTeX code
# 4. Uses LaTeX code to output PDFs
################################################################################
# Code written April 2017 by Jennifer Brussow 
################################################################################

library(dplyr)
library(tidyr)
library(openxlsx)

work_dir <- "S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/"
setwd(work_dir)

filename <- "S:/Projects/DLM Dropbox/TIP pages/TIP workgroup - copies only/math 011817 a.xlsx"

report_out_dir <- "S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/reports"

## STOP UPDATING NOW! ##########################################################
TIPs_file <- read.xlsx(filename)
filename <- unlist(strsplit(filename, split = "/"))
filename <- filename[length(filename)]

new_names <- make.names(names(TIPs_file))
new_names <- gsub("\\.\\.", "\\.", new_names)
new_names <- gsub("\\.\\.", "\\.", new_names)
new_names <- gsub("\\.$", "", new_names)

names(TIPs_file) <- new_names

subject <- NULL
if(grepl("^ELA", filename, ignore.case = TRUE)){
  subject <- "ELA"
} else if(grepl("^M", filename) | grepl("^Math", filename, ignore.case = TRUE)){
  subject <- "M"
} else if(grepl("^Sci", filename , ignore.case = TRUE)){
  subject <- "SCI"
} else {
  stop("Subject not identified from filename! Please check filename formatting.")
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
                                                "", 
                                                   TIPs_file$Exclude.Support.Definitions)
  TIPs_file$Exclude.Support.Definitions <- gsub("TRUE", 
                                                  "Do not define words for the student.", 
                                                  TIPs_file$Exclude.Support.Definitions)
} else if(subject == "M"){
  for(i in 1:nrow(TIPs_file)){
    if(TIPs_file[i, "Exclude.Support.Definitions"] == FALSE & TIPs_file[i, "Exclude.Support.Translation"] == FALSE){
      TIPs_file[i, "Exclude.Support.Translation"] <- "None"
      TIPs_file[i, "Exclude.Support.Definitions"] <- ""
    } else {
      ifelse(TIPs_file[i, "Exclude.Support.Definitions"] == FALSE,
             TIPs_file[i, "Exclude.Support.Definitions"] <- "",
             TIPs_file[i, "Exclude.Support.Definitions"] <- "Definitions (see \"other comments\")")
      ifelse(TIPs_file[i, "Exclude.Support.Translation"] == FALSE,
             TIPs_file[i, "Exclude.Support.Translation"] <- "",
             TIPs_file[i, "Exclude.Support.Translation"] <- "Do not translate words for this student.")
      
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
                                                "", 
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

# saveRDS(TIPs_file, "test_TIPs_file.rds")

if(subject == "ELA"){
  for(file in 1:nrow(TIPs_file)){
    rmarkdown::render('S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/TIPS_ELA_Template.Rmd',  
                      output_file =  paste0(TIPs_file[file, "filename"],".pdf"), 
                      output_dir = report_out_dir)
  }
} else if(subject == "M"){
  for(file in 1:nrow(TIPs_file)){
    rmarkdown::render('S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/TIPS_M_Template.Rmd',  
                      output_file =  paste0(TIPs_file[file, "filename"],".pdf"), 
                      output_dir = report_out_dir)
  }
} else if(subject == "SCI"){
  for(file in 1:nrow(TIPs_file)){
    rmarkdown::render('S:/Projects/DLM Secure/Psychometrician Asst Projects/Jennifer Projects/TIPs Automation/TIPS_SCI_Template.Rmd',  
                      output_file =  paste0(TIPs_file[file, "filename"],".pdf"), 
                      output_dir = report_out_dir)
  }
} 



