# Load required libraries
library(dplyr)
library(tidyr)
library(readr)

# Set the working directory
setwd("C://Dev//Team-SkySci-Analytics//ML Application and Analysis")

# Load the dataset
dataset <- read_csv("ground_weather_merged.csv")

# rename Image Present to Image
# Check the current column names in the dataframe
column_names <- names(dataset)
column_names
# Rename the "Image Present" column to "Image"
new_column_names <- ifelse(column_names == "Image Present", "Image", column_names)

# Update the dataframe with the new column names
names(dataset) <- new_column_names
names(dataset)


# Data preprocessing
# Remove any unnecessary columns
df <- select(dataset, -"Datetime",
-"precp",
-"Wind",
-"wspd",
-"dewPt",
#-"Image Present",
-"Low/Mid Clouds (%)",
-"High Cirrus (%)",
-"Long-lived Contrails (Count)",
-"Contrail-Cirrus (Count)",
-"Day Low/Mid",
-"Day Count Cirrs",
-"Day Count Cont LL",
-"Day Count Cont-Cirrus")

# Handle missing values
df <- na.omit(df)

# Split the dataset into predictors (X) and the target variable (y)
target_variable_column <- "Image"
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
model <- glm(Image ~ ., data = df, family = "binomial")

# Make predictions on the test data
predictions <- predict(model, newdata = df, type = "response")

# Evaluate the model (example: using accuracy)
predicted_classes <- ifelse(predictions > 0.5, 1, 0)
accuracy <- sum(predicted_classes == df$Image) / length(df$Image)
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

# Convert predicted_classes and df$Image to factors with the same levels
predicted_classes <- factor(ifelse(predictions > 0.5, 1, 0))
df$Image <- factor(df$Image)

# Create the confusion matrix
confusion_matrix <- confusionMatrix(predicted_classes, df$Image)

# Print the confusion matrix
print(confusion_matrix)

