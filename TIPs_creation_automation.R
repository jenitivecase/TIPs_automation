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

setwd("S:/Projects/DLM Dropbox/TIP pages/TIP workgroup - copies only")

filename <- "ELA 01112017 a.xlsx"
TIPs_file <- read.xlsx(filename)

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

extra <- NULL
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



LaTeX_code <- paste0(
  "\begin{longtable}{@{}ll@{}}
  \toprule 
  \begin{minipage}[t]{0.48\columnwidth}%
  \raggedright\strut \includegraphics[width=2.52604in,height=1.03542in,bb = 0 0 200 100, draft, type=eps]{media/image1}\strut %
  \end{minipage} & %
  \begin{minipage}[t]{0.48\columnwidth}%
  \raggedright\strut 
  
  \section{", TIPs_file$Operational.Form.Name, "}
  
  \label{operational_form_name}
  
  Testlet Information Page: ", TIPs_file$filename, "\strut %
  \end{minipage}\tabularnewline
  \bottomrule
  \end{longtable}
  
  Testlet Type: ", TIPs_file$Testlet.Type ,"Number of Items: ", TIPs_file$N.of.items, "
  
  Materials Needed: ", TIPs_file$Materials.Needed, "
  
  Materials Use: ", TIPs_file$Materials.Use, "
  
  Suggested Substitute Materials: ", TIPs_file$Materials.Substitute, "
  
  \begin{longtable}{@{}l@{}}
  \toprule 
  \begin{minipage}[t]{0.97\columnwidth}%
  \raggedright\strut DLM Text Title: ", TIPs_file$DLM.Text.Name, "
  
  Type of Text: ", TIPs_file$Type.of.Text, " Familiar or Unfamiliar? ", TIPs_file$Familiar, "
  
  DLM Source Book: ", TIPs_file$Sourcebook, "\strut %
  \end{minipage}\tabularnewline
  \bottomrule
  \end{longtable}
  
  Accessibility supports NOT allowed:
  
  ", TIPs_file$Exclude.Support.Translation, "\n", TIPs_file$Exclude.Support.Definition, "
  
  Other comments: ", TIPs_file$Testlet.Information.Page.Comments, "
  "
)
