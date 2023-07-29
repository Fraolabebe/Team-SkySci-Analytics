# Load required libraries
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("readr")
# install.packages("e1071")
#-------------------------------------------------------------------------------

# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(e1071)
#-------------------------------------------------------------------------------

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ",getwd()), sep="\n")

#===============================================================================
# Load the dataset
# df <- read_csv("ground_weather_preprocessed.csv")
# plot.subtitle <- "Ground Weather Data"

df <- read_csv("atmospheric_weather_preprocessed.csv")
plot.subtitle <- "Atmospheric Weather Data (20KM)"
#===============================================================================




# Split the dataset into predictors (X) and the target variable (y)
target_variable_column <- "image"
X <- select(df, -target_variable_column)
y <- select(df, target_variable_column)
dim(X)[1] == dim(y)[1]
# Perform any additional data preprocessing steps as needed
# For example, scaling/standardizing variables, creating dummy variables, etc.

# Split the dataset into training and testing sets
set.seed(123)  # Set a random seed for reproducibility
train_threshold <- 0.7 # 70% for training
train_indices <- sample(nrow(df), nrow(df) * train_threshold)  
train_data <- df[train_indices, ]
test_data <- df[-train_indices, ]

#-------------------------------------------------------------------------------
svm_model <- svm(image ~ ., data = train_data, 
                 kernel = "radial",   # Kernel choice (options: "linear", "radial", "polynomial", "sigmoid")
                 cost = 1,            # Cost parameter (C)
                 gamma = 0.1,         # Gamma parameter (only applicable for radial, polynomial, and sigmoid kernels)
                 degree = 3)          # Degree parameter (only applicable for polynomial kernel)

# Print the details of the SVM model
print(svm_model)
predictions <- predict(svm_model, newdata = test_data)

# Round the predictions to 1 or 0
rounded_predictions <- ifelse(predictions > 0.5, 1, 0)

# Evaluate the model
accuracy <- sum(rounded_predictions == test_data$image) / nrow(test_data)
cat("Accuracy:", accuracy)

# Create a confusion matrix
confusion_matrix <- table(rounded_predictions, test_data$image)
confusion_matrix
#-------------------------------------------------------------------------------

library(ggplot2)

# Create a dataframe with the actual and predicted values
results <- data.frame(Actual = test_data$image, Predicted = rounded_predictions)

# Confusion matrix plot
confusion_matrix <- table(results$Actual, results$Predicted)

ggplot() +
  geom_tile(data = as.data.frame.table(confusion_matrix),
            aes(x = Var1, y = Var2, fill = Freq), color = "black") +
  geom_text(data = as.data.frame.table(confusion_matrix),
            aes(x = Var1, y = Var2, label = Freq), color = "black", size = 12) +
  labs(x = "Actual", y = "Predicted", fill = "Frequency", title = "Confusion Matrix - SVM Model") +
  scale_fill_gradient(low = "white", high = "forestgreen") +
  theme_minimal()

#-------------------------------------------------------------------------------
# ROC Curve visualization
library(ROCR)
# Create prediction object
pred <- prediction(predictions, test_data$image)
# Create performance object
perf <- performance(pred, "tpr", "fpr")
# Plot the ROC curve
plot(perf, main = "ROC Curve for SVM Model", xlab = "False Positive Rate", ylab = "True Positive Rate")
#-------------------------------------------------------------------------------
# Kernel Selection Visualization
library(pROC)
library(ggplot2)

# Define the kernel types you want to compare
kernel_types <- c("linear", "radial", "polynomial", "sigmoid")

# Function to fit SVM models with different kernels and calculate ROC curves
fit_svm_model <- function(kernel_type) {
  svm_model <- svm(image ~ ., data = train_data, 
                   kernel = kernel_type,
                   cost = 1,
                   gamma = 0.1,
                   degree = 3)
  
  # Predict probabilities for the test data
  probabilities <- predict(svm_model, newdata = test_data, probability = TRUE)
  
  # Calculate the ROC curve
  roc_obj <- roc(test_data$image, probabilities)
  
  # Return the ROC curve object
  roc_obj
}

# Fit SVM models with different kernels and calculate ROC curves
roc_curves <- lapply(kernel_types, fit_svm_model)

# Combine the ROC curves into a data frame
roc_data <- do.call(rbind, lapply(seq_along(kernel_types), function(i) {
  data.frame(kernel = kernel_types[i],
             fpr = roc_curves[[i]]$specificities,
             tpr = roc_curves[[i]]$sensitivities)
}))

# Plot the ROC curves
ggplot(roc_data, aes(x = fpr, y = tpr, color = kernel)) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(x = "False Positive Rate", y = "True Positive Rate", color = "Kernel Type") +
  theme_minimal()

# Plot the ROC curves
ggplot(roc_data, aes(x = fpr, y = tpr, color = kernel)) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(x = "False Positive Rate", y = "True Positive Rate", color = "Kernel Type") +
  theme_minimal()


# Plot the ROC curves with adjusted visual
ggplot(roc_data, aes(x = fpr, y = tpr, color = kernel)) +
  geom_path() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(x = "False Positive Rate", y = "True Positive Rate", color = "Kernel Type") +
  theme_minimal() +
  xlim(0, 1) +
  ylim(0, 1)

# Invert the FPR values
roc_data$fpr_inverted <- 1 - roc_data$fpr

# Plot the ROC curves with inverted FPR and title/subtitle
ggplot(roc_data, aes(x = fpr_inverted, y = tpr, color = kernel)) +
  geom_path() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(x = "False Positive Rate", y = "True Positive Rate", color = "Kernel Type",
       title = "SVM Kernel Comparison Receiver Operating Characteristic (ROC) Curves",
       subtitle = plot.subtitle) +
  theme_minimal() +
  xlim(0, 1) +
  ylim(0, 1)


#-------------------------------------------------------------------------------
# Decision Boundary Visualization

#-------------------------------------------------------------------------------