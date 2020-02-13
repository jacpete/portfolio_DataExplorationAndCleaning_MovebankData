library(ymlthis)
library(markdown)


file.remove('pdf_document.yaml')
yml_empty() %>% 
  yml_output(pdf_document(toc = TRUE,
                          extra_dependencies = c('blindtext', 'color'))) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'pdf_document.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Envionmental_Informatics_Project.Rmd',
                  output_yaml = 'pdf_document.yaml',
                  params = list(type = "pdf",
                                appendix = TRUE))
                  

file.remove('blogdown_html_page.yaml')
yml_empty() %>% 
  yml_output(blogdown::html_page(toc = TRUE)) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'blogdown_html_page.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Envionmental_Informatics_Project.Rmd',
                  output_yaml = 'blogdown_html_page.yaml',
                  params = list(type = "html",
                                appendix = TRUE))
