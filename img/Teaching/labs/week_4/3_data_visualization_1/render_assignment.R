library(cli)
library(quarto)
cli_inform("Finding assignment...")
qmdfile <- list.files(pattern = ".qmd", full.names = TRUE)
if (length(qmdfile) == 0) cli_abort(
  paste(
    "qmd file not found in current working directory:", 
    getwd()
  )
)
if (length(qmdfile) > 1) {
  cli_warn(
    paste(
      "Multiple qmd files found, using the first:",
      basename(qmdfile)
    )
  )
  qmdfile <- qmdfile[1]
}

cli_inform(paste("Rendering assignment html from", qmdfile))
quarto_render(input = qmdfile, execute_params = list(answers = "false"), quiet = TRUE)
cli_inform(paste("Rendering answers html from", qmdfile))
ans_path <- paste0(tools::file_path_sans_ext(basename(qmdfile)), "_answers.html")
quarto_render(input = qmdfile, output_file = ans_path, quiet = TRUE)
