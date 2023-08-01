# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)
library(ggplot2)

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")

# Load the CSV file into a dataframe
df <- read.csv("cross_model_comparison.csv")
colnames(df)
# Rename the ï..Model column to Model
colnames(df)[colnames(df) == "ï..Model"] <- "Model"
colnames(df)

# Round the accuracy and kappa scores to three decimals
df$Accuracy <- round(df$Accuracy, 3)
df$Kappa <- round(df$Kappa, 3)

# Sort the data based on descending Kappa values while maintaining the order of Accuracy
library(dplyr)
df <- df %>%
  arrange(desc(Kappa), desc(Accuracy))

# Reshape the data in a tidy format
library(tidyr)
df_tidy <- df %>% pivot_longer(cols = c(Accuracy, Kappa), names_to = "Metric", values_to = "Score")

# Create the ggplot barplot without ordering the bars
ggplot(df_tidy, aes(x = Model, y = Score, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge", color="black", width = 0.7) +
  geom_text(aes(label = Score), position = position_dodge(width = 0.7), vjust = -0.5) +
  labs(x = "Model", y = "Scores", fill = "Metric",
       title="Cross Model Comparisons of Accuracy & Kappa Metrics",
       subtitle="Level=225mb boosted with Contrail Present Data") +
  scale_fill_manual(values = c("skyblue", "forestgreen"), labels = c("Accuracy", "Kappa")) +
  theme_minimal()
