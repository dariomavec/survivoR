require(jsonlite)
require(logger)
require(dplyr)
log_layout(layout_glue_colors)
devtools::load_all()

datasets <- data(package = "survivoR")$results[,3]

for(dataset in datasets) {
  .data <- get(dataset) %>%
    ungroup()
  jsonlite::write_json(.data, glue('api/json/{dataset}.json'))
  log_info("{dataset}: {paste0(class(.data), collapse = ' | ')}")
}
