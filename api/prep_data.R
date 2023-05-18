require(jsonlite)
require(logger)
require(dplyr)
require(rvest)
require(xml2)
require(htmltools)
log_layout(layout_glue_colors)
devtools::load_all()

datasets <- data(package = "survivoR")$results[,3]

dir.create('temp_html')
for(dataset in datasets) {
  .data <- get(dataset) %>%
    ungroup()
  jsonlite::write_json(.data, glue('api/public/json/{dataset}.json'))
  log_info("{dataset}: {paste0(class(.data), collapse = ' | ')}")

  tools::Rd2HTML(glue("man/{dataset}.Rd"),
                 out = glue("temp_html/{dataset}.html"))
  # Get document
  html_tree <- read_html(glue("temp_html/{dataset}.html")) %>%
    html_node("body") %>%
    html_children()

  # Remove top table
  html_tree %>%
    html_nodes("table") %>%
    xml_remove()

  # Add link
  html_tree %>%
    html_nodes("h2") %>%
    xml_add_parent("a")

  # Point link at right spot
  html_tree %>%
    html_nodes("a") %>%
    xml_set_attr("href", glue("json/{dataset}.json"))

  # Output
  html_tree %>%
    as.character() %>%
    writeLines(glue("api/public/man/{dataset}.html"))

  unlink(glue("temp_html/{dataset}.html"))
}
unlink("temp_html/", recursive = TRUE)
