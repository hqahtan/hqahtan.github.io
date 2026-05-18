# R code for data visualisation lecture 2

setwd("D:/surfdrive/PhD/Teaching/DataWrangling/Material_visualisation_week/Lectures")
library(nycflights13)
library(tidyverse)

flights

# this file generates all the images for the 

ggplot(data = flights) +
  geom_bar(mapping = aes(x = origin))
ggsave("img/bar.png", width = 6, height = 4, dpi = 320)


ggplot(data = flights) +
  geom_histogram(mapping = aes(x = dep_delay))
ggsave("img/hist.png", width = 6, height = 4, dpi = 320)

ggplot(data = flights) +
  geom_histogram(mapping = aes(x = dep_delay)) +
  coord_cartesian(ylim = c(0, 50)) 
ggsave("img/hist_2.png", width = 6, height = 4, dpi = 320)


ggplot(data = flights) +
  geom_density(mapping = aes(x = air_time), fill = "#454545")
ggsave("img/density.png", width = 6, height = 4, dpi = 320)

ggplot(data = flights) +
  geom_point(aes(x = dep_delay, y = arr_delay)) + 
  coord_fixed()
ggsave("img/scatter.png", width = 6, height = 4, dpi = 320)


ggplot(data = flights) +
  geom_point(aes(x = dep_delay, y = arr_delay), alpha = 1 / 100) + 
  coord_fixed()
ggsave("img/scatter2.png", width = 6, height = 4, dpi = 320)


ggplot(data = flights) +
  geom_bin2d(aes(x = dep_delay, y = arr_delay)) + 
  coord_fixed()
ggsave("img/hex.png", width = 6, height = 4, dpi = 320)


ggplot(data = flights) +
  geom_boxplot(aes(x = origin, y = air_time))
ggsave("img/box.png", width = 4, height = 4, dpi = 320)


ggplot(data = flights) +
  geom_boxplot(aes(y = dest, x = air_time))
ggsave("img/box2.png", width = 14, height = 10, dpi = 320)

library(ggridges)
ggplot(data = flights) +
  geom_density_ridges(aes(y = origin, x = air_time, fill = origin)) +
  theme(legend.position = "n")
ggsave("img/ridge.png", width = 4, height = 4, dpi = 320)

flights %>% 
  mutate(log_delay = log10(arr_delay - min(arr_delay, na.rm = TRUE))) %>% 
  ggplot() +
  geom_boxplot(aes(y = carrier, x = log_delay), outlier.shape = NA) +
  coord_cartesian(xlim = c(1.4, 2.4)) +
  facet_wrap(~origin)
ggsave("img/facet.png", width = 6, height = 4, dpi = 320)


library(GGally)
flights[sample(nrow(flights), 1000),] %>% 
  select(dep_delay, arr_delay, air_time, distance) %>% 
  ggpairs()

ggsave("img/pairs.png", width = 6, height = 6, dpi = 320)
