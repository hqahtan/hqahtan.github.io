# R code for clustering lectures
setwd("D:/surfdrive/PhD/Teaching/DataWrangling/Material_clustering_week/Lectures/")
library(tidyverse)
library(patchwork)
library(mclust)


# lecture 1 ----
faithful %>% 
  ggplot(aes(x = eruptions, y = waiting)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Old faithful geyser eruptions",
       x = "Eruption duration", y = "Waiting time")
ggsave("img/faithful.png", width = 6, height = 4, dpi = 300)

dd <- dist(scale(faithful))
hc <- hclust(dd, method = "average")
den <- ggdendrogram(hc, labels = FALSE, rotate = TRUE) + 
  theme_minimal() +
  labs(x = "Observation", y = "Mean intercluster dissimilarity",
       title = "Old faithful hierarchical clustering with average linkage")
den
ggsave("img/hclust.png", width = 6, height = 4, dpi = 300)

den +
  geom_hline(yintercept = c(.83, 1, 2), linetype = 2) +
  scale_y_continuous(breaks = c(0, .83, 1, 2))
ggsave("img/hclust2.png", width = 6, height = 4, dpi = 300)


f9 <- faithful %>% 
  ggplot(aes(x = eruptions, y = waiting, 
             color = as_factor(cutree(hc, h = .83)))) +
  geom_point() +
  theme_minimal() +
  labs(title = "Cutoff = 0.83 || 4 clusters",
       x = "Eruption duration", y = "Waiting time", colour = "cluster") +
  theme(legend.position = "n")
f11 <- faithful %>% 
  ggplot(aes(x = eruptions, y = waiting, 
             color = as_factor(cutree(hc, h = 1)))) +
  geom_point() +
  theme_minimal() +
  labs(title = "Cutoff = 1 || 3 clusters",
       x = "Eruption duration", y = "Waiting time", colour = "cluster") +
  theme(legend.position = "n")
f20 <- faithful %>% 
  ggplot(aes(x = eruptions, y = waiting, 
             color = as_factor(cutree(hc, h = 2)))) +
  geom_point() +
  theme_minimal() +
  labs(title = "Cutoff = 2 || 2 clusters",
       x = "Eruption duration", y = "Waiting time", colour = "cluster") +
  theme(legend.position = "n")

f9 + f11 + f20

ggsave("img/faithful3.png", width = 11, height = 5, dpi = 300)


set.seed(45)
km  <- kmeans(scale(faithful), 2)
km2 <- kmeans(scale(faithful), 2)
km3 <- kmeans(scale(faithful), 2)
ff1 <- faithful %>% 
  ggplot(aes(x = eruptions, y = waiting, color = as_factor(km$cluster))) +
  geom_point() +
  theme_minimal() +
  labs(title = "K-means 1",
       x = "Eruption duration", y = "Waiting time") +
  scale_colour_manual(values = c("black", "grey"), guide = FALSE)
ff1 + ggtitle("Old faithful geyser eruptions (clustered)")
ggsave("img/faithful2.png", width = 6, height = 4, dpi = 300)

ff2 <- faithful %>% 
  ggplot(aes(x = eruptions, y = waiting, color = as_factor(km2$cluster))) +
  geom_point() +
  theme_minimal() +
  labs(title = "K-means 2",
       x = "Eruption duration", y = "Waiting time") +
  scale_colour_manual(values = c("black", "grey"), guide = FALSE)


ff3 <- faithful %>% 
  ggplot(aes(x = eruptions, y = waiting, color = as_factor(km3$cluster))) +
  geom_point() +
  theme_minimal() +
  labs(title = "K-means 3",
       x = "Eruption duration", y = "Waiting time") +
  scale_colour_manual(values = c("black", "grey"), guide = FALSE)

ff1 + ff2 + ff3
ggsave("labelswitch.png", width = 11, height = 5, dpi = 300)


# Lecture 2 ----

km <- kmeans(scale(faithful), 2, iter.max = 100, nstart = 10)
center_df <- data.frame(km$centers) %>% 
  mutate(cluster = as_factor(c(1, 2)))
data.frame(scale(faithful)) %>% 
  ggplot(aes(x = eruptions, y = waiting)) +
  geom_point(aes(colour = as_factor(km$cluster))) +
  geom_point(data = center_df, aes(fill = cluster), size = 4, pch = 21) +
  geom_point(data = center_df, aes(fill = cluster), alpha = 0.2, size = 109, 
             pch = 21, colour = "transparent") +
  geom_point(data = center_df, aes(fill = cluster), alpha = 0.2, size = 80, 
             pch = 21, colour = "transparent") +
  geom_point(data = center_df, aes(fill = cluster), alpha = 0.2, size = 40, 
             pch = 21, colour = "transparent") +
  coord_fixed() +
  theme(legend.position = "n") +
  ggtitle("K-means with euclidian distance")
ggsave("img/kmeanscircle.png", width = 4.74, height = 5.81)




fit_equal <- Mclust(faithful, G = 2, modelNames = "EEE")
fit_diff  <- Mclust(faithful, G = 2, modelNames = "VVV")


png("img/likmclust.png", 800*300/72, 400*300/72, res = 300)
par(mfrow = c(1, 2))
surfacePlot(faithful, fit_equal$parameters, type = "persp", shade = 0.5)
surfacePlot(faithful, fit_equal$parameters, type = "contour")
dev.off()


png("img/mclust.png", 800*300/72, 400*300/72, res = 300)
par(mfrow = c(1, 2))
surfacePlot(faithful, fit_equal$parameters, type = "hdr", 
            prob = c(.9999, .99, .95, .8, .5, .25))
points(faithful)
mtext("Equal volume, shape, orientation", 3, line = 1, cex = 1.2)
surfacePlot(faithful, fit_diff$parameters, type = "hdr", 
            prob = c(.9999, .99, .95, .8, .5, .25), 
            main = "Variable volume, shape, orientation")
points(faithful)
mtext("Variable volume, shape, orientation", 3, line = 1, cex = 1.2)
dev.off()
