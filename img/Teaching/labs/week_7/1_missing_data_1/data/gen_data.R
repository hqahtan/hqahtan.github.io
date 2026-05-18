set.seed(123)

age <- round(runif(500, 18, 70))
gender <- sample(c("Male", "Female"), 
                 size = 500, 
                 replace = TRUE)
income <- round(rnorm(500, mean = age * 7 + 2000, sd = 200))

income <- data.frame(age = age, gender = gender, income = income)
lm(income ~ age + gender, income) |> summary()

saveRDS(income, "data/income.rds")
