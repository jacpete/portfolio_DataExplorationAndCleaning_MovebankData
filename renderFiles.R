library(ymlthis)

baseYML <- yml() %>% 
  yml_title('Exploring MoveBank data and the movement characteristics of barnacle geese') %>% 
  yml_author('Jacob Peterson') %>% 
  yml_date('February, 12, 2020') %>% 
  yml_citations(bibliography = 'dataReferences.bib', 
                csl = 'ecosphere-doi.csl')

file.remove('pdf_document.yaml')
# baseYML %>% 
yml() %>% 
  yml_output(pdf_document(toc = TRUE, 
                          extra_dependencies = c('blindtext', 'color'))) %>% 
  yml_latex_opts(urlcolor = 'blue') %>% 
  use_yml_file(path = 'pdf_document.yaml', git_ignore = TRUE)




htmlYML <- baseYML %>% 
  yml_output(blogdown::html_page(toc = TRUE))
                          


rmarkdown::render(input = 'Envionmental_Informatics_Project_Website.Rmd',
                  output_yaml = 'pdf_document.yaml')


