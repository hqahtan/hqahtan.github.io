library(mclust)
library(tidyverse)
library(patchwork)
library(ggridges)

df <- as_tibble(banknote)
df <- df |> select(-Status)
df |> 
  mutate(across(everything(), scale)) |> 
  pivot_longer(
    cols = everything(),
    names_to = "feature",
    values_to = "value"
  ) |> 
  ggplot(aes(x = value, y = feature, fill = feature)) + 
  geom_density_ridges() +
  scale_fill_viridis_d(guide = "none") +
  theme_minimal()

# we chose diagonal
dnl <- df |> pull(Diagonal)
hist(dnl, breaks = 20)

# fit
fit_E_2 <- Mclust(dnl, G = 2, modelNames = "E")
str(fit_E_2)
fit_E_2$parameters

# bic from slides
- 2 * fit_E_2$loglik + log(nrow(df)) * 4 
fit_E_2$bic


plot(fit_E_2, "density", xlab = "Diagonal measurement")
rug(dnl)


# varying variance model
fit_V_2 <- Mclust(dnl, G = 2, modelNames = "V")
fit_V_2$parameters


plot(fit_V_2, "density", xlab = "Diagonal measurement")
rug(dnl)

# deviance comparison
-2*fit_E_2$loglik
-2*fit_V_2$loglik

# BIC comparison
-fit_E_2$bic
-fit_V_2$bic




# all 6 features
fit <- Mclust(df)
summary(fit)
fit$parameters$mean

# vvv2
VVV2 <- Mclust(df, 2, "VVV")
plot(VVV2, "density")


df |> 
  ggplot(aes(
    x      = Left, 
    y      = Right,
    colour = as_factor(VVV2$classification), 
    size   = VVV2$uncertainty 
  )) +
  geom_point(position = position_jitter()) +
  scale_size(range = c(1, 3)) +
  labs(colour = "Cluster", size = "Uncertainty") +
  theme_minimal()
