# download the labels
y_file <- tempfile(fileext = "rds")
download.file("https://infomdwr.nl/assignments/competition_files/labels_20231002.rds", y_file)
y <- readRDS(y_file)

# functions to compute grade
compute_grade <- function(mse) {
  ifelse(
    mse < 0.8231436, 10, 
    pmin(pmax(-15.75314 + 87.08141*mse - 67.78293*(mse^2), 1), 10)
  )
}
compute_grade_from_predictions <- function(predictions) {
  compute_grade(mean((predictions - y)^2))
}

