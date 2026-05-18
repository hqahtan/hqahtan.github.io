library(tidyverse)
library(psych)

ctypes <- cols(
  .default = col_factor(),
  age = col_double(),
  Medu = col_double(),
  Fedu = col_double(),
  traveltime = col_double(),
  studytime = col_double(),
  failures = col_double(),
  famrel = col_double(),
  freetime = col_double(),
  goout = col_double(),
  Dalc = col_double(),
  Walc = col_double(),
  health = col_double(),
  absences = col_double(),
  G1 = col_double(),
  G2 = col_double(),
  G3 = col_double()
)

student <- read_delim(
  file = "student-mat.csv",
  delim = ";",
  col_types = ctypes
)


fa_fit <- fa(student |> select(G1, G2, G3))

student <-
  student |>
  select(-G1, -G2, -G3) |>
  mutate(score = c(fa_fit$scores))


set.seed(12)
train_idx <- sample(nrow(student), round(nrow(student)*.8))
student_train  <- student[train_idx, ]
student_test   <- student[-train_idx, ] |> select(-score)
student_labels <- student[-train_idx, ] |> pull(score)

# do some amputation here!

write_rds(student_train,  file = "train.rds")
write_rds(student_test,   file = "test.rds")
write_rds(student_labels, file = "labels_20231002.rds")
