# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)

#-------------------------------------------------------------------------------

# NOTE: Set to your working directory 
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")

#-------------------------------------------------------------------------------
# Load target dataset
# df <- read_csv("ground_weather_preprocessed.csv")
# plot.subtitle <- "Ground Weather Data"

df <- read_csv("atmospheric_weather_preprocessed.csv")
plot.subtitle <- "Atmospheric Weather Data (20KM)"
#-------------------------------------------------------------------------------
# Filter the DataFrame to include rows with pressure == 200 or (pressure != 200 and image == 1)
filtered_df <- df %>%
  filter(pressure == 200 | (pressure != 200 & image == 1))

df <- filtered_df %>% select(-pressure)

#-------------------------------------------------------------------------------
# Ground Weather Swap IN
df <- read_csv("ground_weather_preprocessed.csv")
plot.subtitle <- "Ground Weather Data"

#-------------------------------------------------------------------------------

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
k <- 4   # Number of nearest neighbors to consider
model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
             test_data[, -which(names(test_data) == target_variable_column)],
             train_data[[target_variable_column]],
             k)

# Evaluate the model
accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
print(paste("Accuracy:", accuracy))

plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ", 100*round(accuracy,4),'%')
#-------------------------------------------------------------------------------
# Load required library
library(pROC)
library(ggplot2)

#-------------------------------------------------------------------------------
# Calculate the confusion matrix
confusion_matrix <- table(model, test_data[[target_variable_column]])

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

# Calculate the overall observed agreement
observed_agreement <- accuracy

# Calculate the probability of agreement by chance
p_chance <- (sum(confusion_matrix[1,]) * sum(confusion_matrix[,1]) +
               sum(confusion_matrix[2,]) * sum(confusion_matrix[,2])) /
  sum(confusion_matrix)^2

# Calculate Cohen's Kappa
kappa <- (observed_agreement - p_chance) / (1 - p_chance)

# Calculate McNemar's test
mcnemar_test <- mcnemar.test(confusion_matrix)

# Extract the p-value from McNemar's test result
p_value_mcnemar <- mcnemar_test$p.value

# Print the results, including the p-value for McNemar's test
print(paste("Accuracy:", accuracy))
print(paste("Cohen's Kappa:", kappa))
print(paste("McNemar's Test p-value:", p_value_mcnemar))
print(paste("Sensitivity:", sensitivity))
print(paste("Specificity:", specificity))
print(paste("Precision:", precision))

#===============================================================================

# Create ROC curve
roc_data <- roc(test_data[[target_variable_column]], as.numeric(model))
plot(roc_data, print.thres = "best", print.auc = TRUE, grid = TRUE)

# Plot ROC curve
knn.roc.plot <- ggroc(roc_data) +
  labs(title = "Receiver Operating Characteristic (ROC) Curve - KNN Classifier",
       subtitle = plot.subtitle)
knn.roc.plot

#-------------------------------------------------------------------------------
# Create a dataframe with the actual and predicted values
results <- data.frame(Actual = test_data$image, Predicted = model)

# Confusion matrix plot
confusion_matrix <- table(results$Actual, results$Predicted)

# Plot the confusion matrix
ggplot() +
  geom_tile(data = as.data.frame.table(confusion_matrix),
            aes(x = Var1, y = Var2, fill = Freq), color = "black") +
  geom_text(data = as.data.frame.table(confusion_matrix),
            aes(x = Var1, y = Var2, label = Freq), color = "black", size = 12) +
  labs(x = "Actual", y = "Predicted", fill = "Frequency", 
       title = "Confusion Matrix - KNN Model", subtitle = plot.subtitle) +
  scale_fill_gradient(low = "white", high = "forestgreen") +
  theme_minimal()
#-------------------------------------------------------------------------------
library(class)
library(cluster)
library(ggplot2)
library(factoextra)

# Create a function to calculate the total within-cluster sum of squares (WSS)
calculate_wss <- function(data, k) {
  kmeans_model <- kmeans(data, centers = k, nstart = 10)
  wss <- sum(kmeans_model$withinss)
  return(wss)
}

# Generate some sample data with 3 groups
set.seed(42)
data <- matrix(rnorm(300), ncol = 2)
labels <- sample(1:3, size = 100, replace = TRUE)
colors <- c("red", "blue", "green")
df <- data.frame(data, label = factor(labels))

# Calculate WSS for different values of k
wss_values <- sapply(2:10, function(k) calculate_wss(data, k))

# Create a data frame for the elbow plot
elbow_df <- data.frame(k = 2:10, wss = wss_values)

# Create the elbow plot using ggplot2
elbow_plot <- ggplot(elbow_df, aes(x = k, y = wss)) +
  geom_line() +
  geom_point(shape = 19) +
  xlab("Number of clusters (k)") +
  ylab("Total Within-cluster Sum of Squares (WSS)") +
  theme_minimal() +
  labs(title = "Elbow Plot for KNN Classifier",
       subtitle = "Optimal Number of Clusters Selection") +
  geom_vline(xintercept = k, linetype = "dashed", color = "red") +
  annotate("text", x = 2 + 0.2, y = max(wss_values),
           label = paste("Elbow at k =", k), hjust = 0) +
  scale_x_continuous(breaks = seq(2, 10, by = 1))

# Display the elbow plot
print(elbow_plot)
#===============================================================================
library(pROC)
library(ggplot2)

# Compute ROC curve using pROC
roc_data <- roc(response, predictor)

# Extract ROC curve data
roc_df <- data.frame(1 - roc_data$specificities, roc_data$sensitivities)

# Create the ROC plot using ggplot2
roc_plot <- ggplot(roc_df, aes(x = X1...roc_data.specificities, y = roc_data$sensitivities)) +
  geom_path() +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  xlab("False Positive Rate") +
  ylab("True Positive Rate") +
  labs(title = "K-Nearest Neighbors Receiver Operating Characteristic (ROC) Curve",
       subtitle = plot.subtitle) +
  theme_minimal()

# Display the ROC plot
roc_plot
#===============================================================================
# Visualization quick grab
confusion_matrix
print(paste("Sensitivity:", sensitivity,
            "Specificity:", specificity,
            "Precision:", precision,
            "Accuracy:", accuracy))
#knn.roc.plot
roc_plot
elbow_plot

#===============================================================================
install.packages("pROC")
library(class)
library(pROC)# Assuming the class labels are binary (0 and 1) in this example
library(ggplot2)
# Assuming the class labels are binary (0 and 1) in this example
# We'll use the predicted class labels to calculate the ROC curve
roc_curve <- roc(test_data$image, as.numeric(model) - 1)

# Calculate AUC
auc_score <- auc(roc_curve)

# Plot the ROC curve
plot(roc_curve, main = paste("KNN (k=4) ROC Curve ~ AUC =", round(auc_score, 3)))
