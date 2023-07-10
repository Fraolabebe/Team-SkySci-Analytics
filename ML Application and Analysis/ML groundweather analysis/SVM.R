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

# Load the datas`et
df <- read_csv("ground_weather_preprocessed.csv")

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
            aes(x = Var1, y = Var2, fill = Freq)) +
  labs(x = "Actual", y = "Predicted", fill = "Frequency") +
  scale_fill_gradient(low = "white", high = "blue") +
  theme_minimal()

#-------------------------------------------------------------------------------
library(ROCR)
# Create prediction object
pred <- prediction(predictions, test_data$image)
# Create performance object
perf <- performance(pred, "tpr", "fpr")
# Plot the ROC curve
plot(perf, main = "ROC Curve for SVM Model", xlab = "False Positive Rate", ylab = "True Positive Rate")
#-------------------------------------------------------------------------------
