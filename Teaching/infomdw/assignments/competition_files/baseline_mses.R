# Mean squared error for different models
library(tidyverse)
library(ranger)
set.seed(45)

# load data
df_train  <- read_rds("train.rds")
df_test   <- read_rds("test.rds")
y         <- read_rds("labels_20231002.rds")

# trivial baseline
fit_base  <- lm(score ~ 1, df_train)
yhat_base <- predict(fit_base, df_test)
mse_base  <- mean((y - yhat_base)^2)

# basic regression
fit_lm    <- lm(score ~ ., df_train)
yhat_lm   <- predict(fit_lm, df_test)
mse_lm    <- mean((y - yhat_lm)^2)

# good model: random forest
fit_rf    <- ranger(score ~ ., df_train)
yhat_rf   <- predict(fit_rf, df_test)$predictions
mse_rf    <- mean((y - yhat_rf)^2)

# table
mse_ref <- tribble(
  ~model,            ~mse,      ~grade,
  "trivial baseline", mse_base,  5,
  "linear model",     mse_lm,    8,
  "random forest",    mse_rf,    10
)

# create model for grading performance
performance_model <- lm(grade ~ mse + I(mse^2), mse_ref)
coef(performance_model)

compute_grade <- function(mse) {
  pmin(pmax(-15.75314 + 87.08141*mse - 67.78293*(mse^2), 1), 10)
}


# functions to compute grade
compute_grade <- function(mse) {
  raw_grade <- predict(performance_model, tibble(mse = mse))
  pmin(pmax(raw_grade, 1), 10)
}
compute_grade_from_predictions <- function(predictions) {
  compute_grade(mean((predictions - y)^2))
}

# plot
mse_new <- seq(0.7, 1.1, len = 500)
tibble(mse = mse_new, grade = compute_grade(mse_new)) |> 
  ggplot(aes(x = mse, y = grade)) +
  geom_hline(yintercept = 5.5, linetype = 2, colour = "grey") +
  geom_line() +
  geom_point(data = mse_ref) +
  geom_text(data = mse_ref, aes(label = model), hjust = 1, nudge_x = -0.005) +
  scale_x_reverse() +
  scale_y_continuous(breaks = 1:10) +
  theme_minimal() +
  labs(
    title = "Model performance grade", 
    y = "Grade", 
    x = "Performance (mean squared error)"
  )

ggsave("performance_grade.png", width = 6, height = 6, bg = "white")


