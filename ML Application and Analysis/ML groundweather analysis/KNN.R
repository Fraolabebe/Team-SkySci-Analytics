# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)

#-------------------------------------------------------------------------------

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")

# Load the dataset
df <- read_csv("ground_weather_preprocessed.csv")

# Split the dataset into predictors (X) and the target variable (y)
target_variable_column <- "image"
X <- select(df, -target_variable_column)
y <- df[[target_variable_column]]

# Perform any additional data preprocessing steps as needed
# For example, scaling/standardizing variables, creating dummy variables, etc.

# Split the dataset into training and testing sets
set.seed(123)  # Set a random seed for reproducibility
train_threshold <- 0.7 # 70% for training
train_indices <- sample(nrow(df), nrow(df) * train_threshold)  
train_data <- df[train_indices, ]
test_data <- df[-train_indices, ]

# Train the KNN classifier model
k <- 3  # Number of nearest neighbors to consider
model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
             test_data[, -which(names(test_data) == target_variable_column)],
             train_data[[target_variable_column]],
             k)

# Evaluate the model
accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
print(paste("Accuracy:", accuracy))

#-------------------------------------------------------------------------------
# Load required library
library(pROC)
library(ggplot2)

#-------------------------------------------------------------------------------
# Calculate the confusion matrix
confusion_matrix <- table(model, test_data[[target_variable_column]])
print("Confusion Matrix:")
print(confusion_matrix)

# Calculate True Positive, True Negative, False Positive, and False Negative
tp <- confusion_matrix[2, 2]
tn <- confusion_matrix[1, 1]
fp <- confusion_matrix[1, 2]
fn <- confusion_matrix[2, 1]

# Calculate Sensitivity, Specificity, Precision, and Accuracy
sensitivity <- tp / (tp + fn)
specificity <- tn / (tn + fp)
precision <- tp / (tp + fp)
accuracy <- (tp + tn) / sum(confusion_matrix)

print(paste("Sensitivity:", sensitivity,
            "Specificity:", specificity,
            "Precision:", precision,
            "Accuracy:", accuracy))

# Create ROC curve
roc_data <- roc(test_data[[target_variable_column]], as.numeric(model))
plot(roc_data, print.thres = "best", print.auc = TRUE, grid = TRUE)

# Plot ROC curve
ggroc(roc_data) +
  labs(title = "Receiver Operating Characteristic (ROC) Curve - KNN Classifier",
       subtitle="Ground Weather Data")


#-------------------------------------------------------------------------------