# installing keras in R

install.packages("reticulate")
# restart r session (ctrl+shift+f10)

reticulate::install_miniconda()

# restart r session (ctrl+shift+f10)

reticulate::conda_install("r-reticulate", packages = c("tensorflow", "keras"))

# restart r session (ctrl+shift+f10)

install.packages("remotes")
remotes::install_github("rstudio/tensorflow")
install.packages("keras")

# restart r session (ctrl+shift+f10)

keras::is_keras_available()
# should be true, then you're good to go!!!
# ignore the 1000 warnings :)