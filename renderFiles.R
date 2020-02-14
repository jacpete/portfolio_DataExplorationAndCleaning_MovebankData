library(ymlthis)
library(markdown)
library(readr)
library(stringr)

####Render PDF####
file.remove('pdf_document.yaml'); yml_empty() %>% 
  yml_output(bookdown::pdf_document2(toc = FALSE,
                          extra_dependencies = c('blindtext', 'color'))) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'pdf_document.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Environmental_Informatics_Project.Rmd',
                  output_yaml = 'pdf_document.yaml',
                  params = list(type = "pdf",
                                appendix = FALSE)) 
                  
####Render HTML for Blogdown####
file.remove('blogdown_html_page.yaml'); yml_empty() %>% 
  yml_output(blogdown::html_page(toc = TRUE,
                                 fig_caption = TRUE)) %>%
  yml_pluck("output") %>%
  use_yml_file(path = 'blogdown_html_page.yaml', git_ignore = TRUE)

rmarkdown::render(input = 'Environmental_Informatics_Project.Rmd',
                  output_yaml = 'blogdown_html_page.yaml',
                  params = list(type = "html",
                                appendix = FALSE))


#Created this because YMLthis was handling single taxonomy values in a way that caused errors when Hugo rendered the site
#if a single taxonomy was like this
# categories: R
#instead of:
# categories: ['R']
#OR this:
# categories:
#   - R
#I would run into errors rendering the site. YMLthis would defaults to the incorrect behavior even if it read in a YAML formatted correctly.
forceTaxonomyYML <- function(yml, taxonomies = c("tags", "categories", "library_tags", "authors")) {
  
  #Find Which Taxonomies Present
  taxContain <- names(yml)[which(names(yml) %in% taxonomies)]
  taxData <- yml[taxContain]
  
  #Create Taxonomy String Vector containing a id for each line in the new taxonomy YAML portion
  taxStrings <-  purrr::map2_chr(names(taxData), taxData, function(taxName, taxVars) {
    if (length(taxVars) != 0) {
      taxHead <- paste0(taxName,':\n')
      taxBody <- purrr::map_chr(taxVars, ~paste0("  - ", .x, "\n"))
      taxFull <- paste0(c(taxHead,taxBody), collapse = "")
    } else {
      taxFull <- paste0(taxName,': []\n')
    }
    return(taxFull)
  }) %>% 
    paste0(., collapse = "") %>% 
    stringr::str_split(pattern = "\n") %>% 
    `[[`(1) %>%  
    stringi::stri_remove_empty(.) 
  
  
  #Remove old Taxonomy Datach
  ymlVec <- yml %>% ymlthis::yml_discard(taxContain) %>%
    capture.output()
  
  #Combine base YAML Vector with new taxonomy vector
  ymlVec <- c(ymlVec[1:(length(ymlVec)-1)], taxStrings)
  
  return(ymlVec)
}


createBlogdownHtml <- function(rmdFile, htmlFile, outputYAML, outputName, discard, taxonomies) {
  #Read in RMD File
  rmdFile <- readr::read_lines(rmdFile)
  
  #Extract YAML from RMD
  ymlIDs <- stringr::str_which(rmdFile, pattern = "---")
  ymlRmd <- rmdFile[(ymlIDs[1]+1):(ymlIDs[2]-1)] 
  
  #Ensure there is no output and params section in the YAML, as we are adding our own
  ymlRmd <- ymlRmd %>%
    paste0(collapse = "\n") %>% 
    ymlthis::as_yml() %>%  
    ymlthis::yml_discard(discard) %>%
    forceTaxonomyYML(., taxonomies = taxonomies)
  
  #Get Output YAML
  ymlOutput <- capture.output(outputYAML)

  #Combine to the full YAML
  ymlFull <- c(ymlRmd, 
               ymlOutput[2:length(ymlOutput)],
               c(''))
  
  #Read in HTML file
  htmlFile <- readr::read_lines(htmlFile)
  
  #Write New HTML
  readr::write_lines(c(ymlFull,htmlFile), path = outputName)
}

createBlogdownHtml(rmdFile = "Environmental_Informatics_Project.Rmd",
                   htmlFile = "Environmental_Informatics_Project.html",
                   outputYAML = (yml_empty() %>% 
                                   yml_params(type = 'html', 
                                              appendix = FALSE) %>% 
                                   yml_output(blogdown::html_page(toc = TRUE,
                                                                  fig_caption = TRUE))),
                   outputName = "Environmental_Informatics_Project.html",
                   discard = c("output", "params", "bibliography", 'csl', 'urlcolor', 'linkcolor', 'header_includes'),
                   taxonomies = c("tags", "categories", "library_tags", "authors")
)




#Fix hashtags in table so the markdown doesn't render it as a heading
htmlFileName <- "Environmental_Informatics_Project.html"

#Read in HTML file
htmlFile <- readr::read_lines(htmlFileName) %>% 
  stringr::str_replace(pattern = '^#[:blank:]+', '&#35; ')

#Write New HTML
readr::write_lines(htmlFile, path = htmlFileName)


#now take the html file and copy it to the content folder you want it at
#it will automatically pull over the content directory it needs
#rename it from html extension to Rmd (may have to do it twice and ignore warnings)
#render the site, the content folder will disappear and folders in the static directory with the content will be created
#to replace with new version delete all files and repeat process






