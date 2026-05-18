# function to render qmd without and with answers
library(rstudioapi)
library(quarto)
library(cli)

render_assignment <- function(questions = TRUE, answers = TRUE, append_hash = TRUE) {
  oldwd <- getwd()
  rid <- rstudioapi::documentId(allowConsole = FALSE)
  
  pth <- tryCatch(
    expr = rstudioapi::documentPath(id = rid), 
    error = \(e) cli::cli_abort("Save your file as .qmd before rendering!")
  )
  
  if (tolower(tools::file_ext(pth)) != "qmd") 
    cli::cli_abort("Open a .qmd file and then run render_assignment().")
  
  setwd(dirname(pth))
  on.exit(setwd(oldwd))
  
  if (questions) {
    cli::cli_inform("Rendering assignment file without answers...")
    out_pth <- paste0(tools::file_path_sans_ext(basename(pth)), ".html")
    quarto::quarto_render(
      input = pth,
      execute_params = list(answers = "false")
    )
  }
  
  if (answers) {
    cli::cli_inform("Rendering answers file...")
    hash <- if (append_hash) paste0("_", substr(cli::hash_md5(rnorm(1)), 1, 6)) else ""
    ans_path <- paste0(tools::file_path_sans_ext(basename(pth)), "_answers", hash, ".html")
    quarto::quarto_render(
      input = pth, 
      output_file = ans_path,
      execute_params = list(answers = "true")
    )
  }
}