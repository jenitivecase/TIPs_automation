
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
