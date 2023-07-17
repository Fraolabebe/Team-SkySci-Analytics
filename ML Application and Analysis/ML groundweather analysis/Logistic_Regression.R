# Load required libraries
library(dplyr)
library(tidyr)
library(readr)

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ",getwd()), sep="\n")

# Load the dataset
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
train_indices <- sample(nrow(df), nrow(df) * 0.7)  # 70% for training
train_data <- X[train_indices, ]
test_data <- y[-train_indices, ]

#------------------------
model <- glm(image ~ ., data = df, family = "binomial")

# Make predictions on the test data
predictions <- predict(model, newdata = df, type = "response")

# Evaluate the model (example: using accuracy)
predicted_classes <- ifelse(predictions > 0.5, 1, 0)
accuracy <- sum(predicted_classes == df$image) / length(df$image)
cat("Accuracy:", accuracy)
#------------------------
# Create a confusion matrix below
#------------------------
# Install the "caret" package if it's not already installed
# install.packages("caret")

# Load the required libraries
library(caret)

# Make predictions on the test data
predictions <- predict(model, newdata = df, type = "response")

# Convert predicted_classes and df$image to factors with the same levels
predicted_classes <- factor(ifelse(predictions > 0.5, 1, 0))
df$image <- factor(df$image)

# Create the confusion matrix
confusion_matrix <- confusionMatrix(predicted_classes, df$image)

# Print the confusion matrix
confusion_matrix
#-------------------------------------------------------------------------------
# VISUALIZATIONS
#-------------------------------------------------------------------------------
# Default Visual
library(pROC)
roc_obj <- roc(df$image, predictions)
plot(roc_obj, main = "Receiver Operating Characteristic (ROC) Curve")

pr_obj <- roc(df$image, predictions, direction = "<")
plot(pr_obj, main = "Precision-Recall Curve")

# Error: Unable to load package rms on my linux box
install.packages("rms")
library(rms)
calibration_plot <- calibration(predictions, df$image, method = "bins")
plot(calibration_plot, main = "Calibration Plot")
#-------------------------------------------------------------------------------
# ggPlot  Visual
library(pROC)
library(ggplot2)

# ROC Curve
roc_obj <- roc(df$image, predictions)

roc_data <- data.frame(
  "FPR" = roc_obj$specificities,
  "TPR" = roc_obj$sensitivities
)

roc_plot <- ggplot(roc_data, aes(x = FPR, y = TPR)) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(x = "False Positive Rate", y = "True Positive Rate") +
  ggtitle("Receiver Operating Characteristic (ROC) Curve")

roc_plot

#========================================
# Precision Recall Visualization
# Precision: measures the accuracy of positive predictions made by a model
# Precision = True Positives / (True Positives + False Positives)
# Recall: measures ability of a model to identify positive instances correctly
# Recall = True Positives / (True Positives + False Negatives)
#========================================
pr_obj <- roc(df$image, predictions, direction = "<")

# Calculate Precision
pr_data <- data.frame(
  "Recall" = pr_obj$sensitivities,
  "Specificity" = pr_obj$specificities
)

pr_data$Precision <- with(pr_data, Recall / (Recall + (1 - Specificity)))

# Filter out rows with missing values
pr_data <- pr_data[complete.cases(pr_data), ]

pr_plot <- ggplot(pr_data, aes(x = Recall, y = Precision)) +
  geom_line() +
  labs(x = "Recall", y = "Precision") +
  ggtitle("Precision-Recall Curve")

pr_plot

# Heatmap of Original Dataset w/targeted attributes
library(ggplot2)
# Calculate correlation matrix
numeric_df <- df[, sapply(df, is.numeric)]
cor_matrix <- cor(numeric_df)

# Convert correlation matrix to long format
cor_data <- reshape2::melt(cor_matrix)

# Create correlation heatmap using ggplot2
heatmap_plot <- ggplot(cor_data, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(x = "Variable 1", y = "Variable 2", title = "Correlation Heatmap") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3)

heatmap_plot

#===============================================================================
# Display Outputs
#===============================================================================
heatmap_plot
confusion_matrix
roc_plot
pr_plot

#===============================================================================

# Fit the logistic regression model and get the coefficients
model <- glm(image ~ ., data = df, family = "binomial")
coefficients <- coef(model)
sorted_coefficients <- sort(abs(coefficients), decreasing = TRUE)

# Variables with larger absolute coefficients have a stronger influence
# on the prediction
print(`sorted_coefficients`)

# Remove the intercept coefficient
predictor_coef <- sorted_coefficients[-1]
coef_data <- data.frame(Variable = names(predictor_coef), Coefficient = predictor_coef)


# Sort the coefficients by their absolute values for easier interpretation
coef_data <- coef_data[order(abs(coef_data$Coefficient), decreasing = TRUE), ]

coef_plot <- ggplot(coef_data, aes(x = Variable, y = Coefficient, fill = Coefficient > 0.4999)) +
  geom_bar(stat = "identity", color = "black") +
  labs(x = "Predictor Variable", y = "Coefficient Magnitude", title = "Comparison of Coefficients") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("coral", "forestgreen"), labels = c("Minority", "Majority"), guide = guide_legend(reverse = TRUE)) +
  coord_cartesian(ylim = c(0.0, 1.0))

# Display the bar plot
coef_plot
