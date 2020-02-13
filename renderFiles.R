library(ymlthis)
library(markdown)
library(readr)
library(stringr)


file.remove('pdf_document.yaml'); yml_empty() %>% 
  yml_output(bookdown::pdf_document2(toc = FALSE,
                          extra_dependencies = c('blindtext', 'color'))) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'pdf_document.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Environmental_Informatics_Project.Rmd',
                  output_yaml = 'pdf_document.yaml',
                  params = list(type = "pdf",
                                appendix = FALSE)) 
                  

file.remove('blogdown_html_page.yaml'); yml_empty() %>% 
  yml_output(blogdown::html_page(toc = TRUE,
                                 fig_caption = TRUE)) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'blogdown_html_page.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Environmental_Informatics_Project.Rmd',
                  output_yaml = 'blogdown_html_page.yaml',
                  params = list(type = "html",
                                appendix = TRUE))



createBlogdownHTML <- function(rmdFile, htmlFile, outputYAML, outputName) {
  #Read in RMD File
  rmdFile <- readr::read_lines(rmdFile)
  
  #Extract YAML from RMD
  ymlIDs <- stringr::str_which(rmdFile, pattern = "---")
  ymlRmd <- rmdFile[(ymlIDs[1]+1):(ymlIDs[2]-1)] 
  
  #Ensure there is no output section in the YAML, as we are adding our own
  ymlRmd <- ymlRmd %>% 
    paste0(collapse = "\n") %>% 
    ymlthis::as_yml() %>%  
    ymlthis::yml_discard("output") %>% 
    capture.output()
  
  #Get Output YAML
  ymlOutput <- capture.output(outputYAML)

  #Combine to the full YAML
  ymlFull <- c(ymlRmd[1:(length(ymlRmd)-1)], 
               ymlOutput[2:length(ymlOutput)],
               c(''))
  
  #Read in HTML file
  htmlFile <- readr::read_lines(htmlFile)
  
  #Write New HTML fil
  readr::write_lines(c(ymlFull,htmlFile), path = outputName)
}

createBlogdownHTML(rmdFile = "Environmental_Informatics_Project.Rmd",
                   htmlFile = "Environmental_Informatics_Project.html",
                   outputYAML = (yml_empty() %>% 
                                   yml_output(blogdown::html_page(toc = TRUE,
                                                                  fig_caption = TRUE))),
                   outputName = "Environmental_Informatics_Project.html"
)











