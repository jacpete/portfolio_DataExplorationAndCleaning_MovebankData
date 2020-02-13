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







