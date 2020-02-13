library(ymlthis)
library(markdown)


# file.remove('pdf_document.yaml')
# yml_empty() %>% 
#   yml_output(pdf_document(toc = TRUE,
#                           extra_dependencies = c('blindtext', 'color'))) %>%
#   yml_pluck("output") %>%
#   use_yml_file(path = 'pdf_document.yaml', git_ignore = TRUE)
file.remove('pdf_document.yaml'); yml_empty() %>% 
  yml_output(bookdown::pdf_document2(toc = FALSE,
                          extra_dependencies = c('blindtext', 'color'),
                          keep_md = TRUE,
                          keep_tex = TRUE)) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'pdf_document.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Envionmental_Informatics_Project.Rmd',
                  output_yaml = 'pdf_document.yaml',
                  params = list(type = "pdf",
                                appendix = FALSE))
                  

file.remove('blogdown_html_page.yaml'); yml_empty() %>% 
  yml_output(blogdown::html_page(toc = TRUE,
                                 fig_caption = TRUE,
                                 keep_md = TRUE)) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'blogdown_html_page.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Envionmental_Informatics_Project.Rmd',
                  output_yaml = 'blogdown_html_page.yaml',
                  params = list(type = "html",
                                appendix = TRUE))

library(readr)
library(stringr)


createBlogdownHTML <- function(rmdFile, htmlFile, outputYAML, outputName) {
  #Read in RMD File
  rmdFile <- readr::read_lines(rmdFile)
  
  #Extract YAML from RMD
  ymlIDs <- stringr::str_which(rmdFile, pattern = "---")
  ymlRmd <- rmdFile[ymlIDs[1]:(ymlIDs[2]-1)]
  
  #Get Output YAML
  ymlOutput <- capture.output(outputYAML)
  cat(ymlOutput)
  
  #Combine to the full YAML
  ymlFull <- c(ymlRmd, 
               c('', '#output Parameters'),
               ymlOutput[2:length(ymlOutput)],
               c(''))
  
  #Read in HTML file
  htmlFile <- readr::read_lines(htmlFile)
  
  cat("\n")
  cat(getwd())
  
  cat("\n")
  # cat(c(ymlFull,htmlFile))
  #Write New HTML fil
  readr::write_lines(c(ymlFull,htmlFile), path = outputName)
  cat(file.exists(outputName))
}

createBlogdownHTML(rmdFile = "Envionmental_informatics_Project.Rmd",
                   htmlFile = "Envionmental_informatics_Project.html",
                   outputYAML = (yml_empty() %>% 
                                   yml_output(blogdown::html_page(toc = TRUE,
                                                                  fig_caption = TRUE))),
                   outputName = "Test.html"
)



## Create YAML Header
rmdFile <- read_lines("Envionmental_informatics_Project.Rmd")
ymlIDs <- stringr::str_which(rmdFile, pattern = "---")
ymlRmd <- rmdFile[ymlIDs[1]:(ymlIDs[2]-1)]
ymlOutput <- yml_empty() %>% 
  yml_output(blogdown::html_page(toc = TRUE,
                                 fig_caption = TRUE)) %>% 
  capture.output(.)
ymlFull <- c(ymlRmd, 
             c('', '#output Parameters'),
             ymlOutput[2:length(ymlOutput)],
             c(''))


cat(paste0(ymlFull, collapse = "\n"))



htmlFile <- read_lines("Envionmental_informatics_Project.html")



write_lines(c(ymlFull,htmlFile), path = "test.html")







