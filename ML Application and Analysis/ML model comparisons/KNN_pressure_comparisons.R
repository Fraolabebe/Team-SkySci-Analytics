# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)
library(ggplot2)

#===============================================================================
# Set working directory to files current directory
{
# NOTE: Set to your working directory 
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")
#-------------------------------------------------------------------------------
df <- read_csv("atmospheric_weather_preprocessed.csv")
#plot.subtitle <- "Atmospheric Weather Data (20KM)"
levels_interested <- c(200, 225, 250, 275, 300)
}
#===============================================================================
# Create comparison dataframe
comparison.df <- data.frame(
  Level = numeric(),
  Accuracy = numeric(),
  Cohen_Kappa = numeric(),
  McNemars_Test_p_value = numeric(),
  Sensitivity = numeric(),
  Specificity = numeric(),
  Precision = numeric(),
  stringsAsFactors = FALSE
)
#===============================================================================
# Pressure Level 200 modeling KNN
{
level <- 200
plot.subtitle <- "Atmospheric Weather Data (Level = 200mb)"
df.200 <- df %>% filter(pressure == 200)
df.200 <- df.200 %>% select(-pressure)
# Split the dataset into predictors (X) and the target variable (y)
target_variable_column <- "image"
X <- select(df.200, -target_variable_column)
y <- df.200[[target_variable_column]]
# Split the dataset into training and testing sets
set.seed(123)
train_threshold <- 0.7 # 70% for training
train_indices <- sample(nrow(df.200), nrow(df.200) * train_threshold)  
train_data <- df.200[train_indices, ]
test_data <- df.200[-train_indices, ]
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

kappa <- (observed_agreement - p_chance) / (1 - p_chance)
mcnemar_test <- mcnemar.test(confusion_matrix)
p_value_mcnemar <- mcnemar_test$p.value

model.stats <- list(
  Level = level,
  Accuracy = accuracy,
  Cohen_Kappa = kappa,
  McNemars_Test_p_value = p_value_mcnemar,
  Sensitivity = sensitivity,
  Specificity = specificity,
  Precision = precision
)
comparison.df <- rbind(comparison.df, model.stats)
#-------------------------------------------------------------------------------
# Create a dataframe with the actual and predicted values
results <- data.frame(Actual = test_data$image, Predicted = model)

# Confusion matrix plot
confusion_matrix <- table(results$Actual, results$Predicted)

# Relabel for confusion matrix
plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                       100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
#===============================================================================
# Pressure Level 225 modeling
{
level <- 225
plot.subtitle <- "Atmospheric Weather Data (Level = 225mb)"
df.225 <- df %>% select(-pressure)
df.225 <- df %>% filter(pressure == 225)
# Split the dataset into predictors (X) and the target variable (y)
target_variable_column <- "image"
X <- select(df.225, -target_variable_column)
y <- df.225[[target_variable_column]]
# Split the dataset into training and testing sets
set.seed(123)
train_threshold <- 0.7 # 70% for training
train_indices <- sample(nrow(df.225), nrow(df.225) * train_threshold)  
train_data <- df.225[train_indices, ]
test_data <- df.225[-train_indices, ]
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

kappa <- (observed_agreement - p_chance) / (1 - p_chance)
mcnemar_test <- mcnemar.test(confusion_matrix)
p_value_mcnemar <- mcnemar_test$p.value

model.stats <- list(
  Level = level,
  Accuracy = accuracy,
  Cohen_Kappa = kappa,
  McNemars_Test_p_value = p_value_mcnemar,
  Sensitivity = sensitivity,
  Specificity = specificity,
  Precision = precision
)
comparison.df <- rbind(comparison.df, model.stats)

#-------------------------------------------------------------------------------
# Create a dataframe with the actual and predicted values
results <- data.frame(Actual = test_data$image, Predicted = model)

# Confusion matrix plot
confusion_matrix <- table(results$Actual, results$Predicted)

# Relabel for confusion matrix
plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                       100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
#===============================================================================
# Pressure Level 250 modeling
{
level <- 250
plot.subtitle <- "Atmospheric Weather Data (Level = 250mb)"
  df.250 <- df %>% select(-pressure)
  df.250 <- df %>% filter(pressure == 250)
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.250, -target_variable_column)
  y <- df.250[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.250), nrow(df.250) * train_threshold)  
  train_data <- df.250[train_indices, ]
  test_data <- df.250[-train_indices, ]
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
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
}
#===============================================================================
# Pressure Level 275 modeling
{
  level <- 275
  plot.subtitle <- "Atmospheric Weather Data (Level = 275mb)"
  df.275 <- df %>% select(-pressure)
  df.275 <- df %>% filter(pressure == 275)
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.275, -target_variable_column)
  y <- df.275[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.275), nrow(df.275) * train_threshold)  
  train_data <- df.275[train_indices, ]
  test_data <- df.275[-train_indices, ]
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
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
  
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
}
#===============================================================================
# Pressure Level 300 modeling
{
  level <- 300
  plot.subtitle <- "Atmospheric Weather Data (Level = 300mb)"
  df.300 <- df %>% select(-pressure)
  df.300 <- df %>% filter(pressure == 300)
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.300, -target_variable_column)
  y <- df.300[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.300), nrow(df.300) * train_threshold)  
  train_data <- df.300[train_indices, ]
  test_data <- df.300[-train_indices, ]
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
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
#===============================================================================
# All Pressure Levels modeling 200
{
  level <- 2000
  level.modifier <- 200
  plot.subtitle <- paste("Atmospheric Weather Data (Level = ",
  level.modifier, "mb and any contrail present)")
  df.all <- df %>%
    filter(pressure == level.modifier | (pressure != level.modifier & image == 1))
  
  df <- df.all %>% select(-pressure)
  
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.all, -target_variable_column)
  y <- df.all[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.all), nrow(df.all) * train_threshold)  
  train_data <- df.all[train_indices, ]
  test_data <- df.all[-train_indices, ]
  # Train the KNN classifier model
  k <- 4   # Number of nearest neighbors to consider
  model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
               test_data[, -which(names(test_data) == target_variable_column)],
               train_data[[target_variable_column]],
               k)
  # Evaluate the model
  accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
  print(paste("Accuracy:", accuracy))
  #plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ", 100*round(accuracy,4),'%')
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
# All Pressure Levels modeling 225
{
  level <- 2250
  level.modifier <- 225
  plot.subtitle <- paste("Atmospheric Weather Data (Level = ",
  level.modifier, "mb and any contrail present)")
  df.all <- df %>%
    filter(pressure == level.modifier | (pressure != level.modifier & image == 1))
  
  df <- df.all %>% select(-pressure)
  
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.all, -target_variable_column)
  y <- df.all[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.all), nrow(df.all) * train_threshold)  
  train_data <- df.all[train_indices, ]
  test_data <- df.all[-train_indices, ]
  # Train the KNN classifier model
  k <- 4   # Number of nearest neighbors to consider
  model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
               test_data[, -which(names(test_data) == target_variable_column)],
               train_data[[target_variable_column]],
               k)
  # Evaluate the model
  accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
  print(paste("Accuracy:", accuracy))
  #plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ", 100*round(accuracy,4),'%')
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
# All Pressure Levels modeling 250
{
  level <- 2500
  level.modifier <- 250
  plot.subtitle <- paste("Atmospheric Weather Data (Level = ",
  level.modifier, "mb and any contrail present)")
  df.all <- df %>%
    filter(pressure == level.modifier | (pressure != level.modifier & image == 1))
  
  df <- df.all %>% select(-pressure)
  
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.all, -target_variable_column)
  y <- df.all[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.all), nrow(df.all) * train_threshold)  
  train_data <- df.all[train_indices, ]
  test_data <- df.all[-train_indices, ]
  # Train the KNN classifier model
  k <- 4   # Number of nearest neighbors to consider
  model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
               test_data[, -which(names(test_data) == target_variable_column)],
               train_data[[target_variable_column]],
               k)
  # Evaluate the model
  accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
  print(paste("Accuracy:", accuracy))
  #plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ", 100*round(accuracy,4),'%')
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
# All Pressure Levels modeling 275
{
  level <- 2750
  level.modifier <- 275
  plot.subtitle <- paste("Atmospheric Weather Data (Level = ",
  level.modifier, "mb and any contrail present)")
  df.all <- df %>%
    filter(pressure == level.modifier | (pressure != level.modifier & image == 1))
  
  df <- df.all %>% select(-pressure)
  
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.all, -target_variable_column)
  y <- df.all[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.all), nrow(df.all) * train_threshold)  
  train_data <- df.all[train_indices, ]
  test_data <- df.all[-train_indices, ]
  # Train the KNN classifier model
  k <- 4   # Number of nearest neighbors to consider
  model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
               test_data[, -which(names(test_data) == target_variable_column)],
               train_data[[target_variable_column]],
               k)
  # Evaluate the model
  accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
  print(paste("Accuracy:", accuracy))
  #plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ", 100*round(accuracy,4),'%')
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
# All Pressure Levels modeling 300
{
  level <- 3000
  level.modifier <- 300
  plot.subtitle <- paste("Atmospheric Weather Data (Level = ",
  level.modifier, "mb and any contrail present)")
  df.all <- df %>%
    filter(pressure == level.modifier | (pressure != level.modifier & image == 1))
  
  df <- df.all %>% select(-pressure)
  
  # Split the dataset into predictors (X) and the target variable (y)
  target_variable_column <- "image"
  X <- select(df.all, -target_variable_column)
  y <- df.all[[target_variable_column]]
  # Split the dataset into training and testing sets
  set.seed(123)
  train_threshold <- 0.7 # 70% for training
  train_indices <- sample(nrow(df.all), nrow(df.all) * train_threshold)  
  train_data <- df.all[train_indices, ]
  test_data <- df.all[-train_indices, ]
  # Train the KNN classifier model
  k <- 4   # Number of nearest neighbors to consider
  model <- knn(train_data[, -which(names(train_data) == target_variable_column)],
               test_data[, -which(names(test_data) == target_variable_column)],
               train_data[[target_variable_column]],
               k)
  # Evaluate the model
  accuracy <- sum(model == test_data[[target_variable_column]]) / nrow(test_data)
  print(paste("Accuracy:", accuracy))
  #plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ", 100*round(accuracy,4),'%')
  #-----------------------------------------------------------------------------
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
  
  kappa <- (observed_agreement - p_chance) / (1 - p_chance)
  mcnemar_test <- mcnemar.test(confusion_matrix)
  p_value_mcnemar <- mcnemar_test$p.value
  
  model.stats <- list(
    Level = level,
    Accuracy = accuracy,
    Cohen_Kappa = kappa,
    McNemars_Test_p_value = p_value_mcnemar,
    Sensitivity = sensitivity,
    Specificity = specificity,
    Precision = precision
  )
  comparison.df <- rbind(comparison.df, model.stats)
  #-------------------------------------------------------------------------------
  # Create a dataframe with the actual and predicted values
  results <- data.frame(Actual = test_data$image, Predicted = model)
  
  # Confusion matrix plot
  confusion_matrix <- table(results$Actual, results$Predicted)
  
  # Relabel for confusion matrix
  plot.subtitle <- paste(plot.subtitle, " [", k, " Clusters]  Accuracy ",
                         100*round(accuracy,4),'% | Kappa ', round(kappa,4))
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
}
#===============================================================================

# Export the dataframe for analysis
comparison.df
# Export the dataframe to a CSV file named 'comparison.csv'
write.csv(comparison.df, file = "model_comparison.csv", row.names = FALSE)
#===============================================================================
#Visualize model differences

# ggplot(comparison.df, aes(x = as.factor(Level), y = Accuracy)) +
#   geom_bar(stat = "identity", fill = "blue", alpha = 0.6) +
#   geom_bar(stat = "identity", fill = "red", alpha = 0.6) +
#   labs(title = "Accuracy by Level",
#        x = "Level",
#        y = "Score")

#-------------------------------------------------------------------------------
# ggplot(comparison.df, aes(x = as.factor(Level), y = Cohen_Kappa)) +
#   geom_bar(stat = "identity", fill = "blue", alpha = 0.8) +
#   labs(title = "Cohen's Kappa by Level",
#        x = "Level",
#        y = "Score")

#-------------------------------------------------------------------------------
# Create a ggplot barplot with a legend
round.to <- 3
{
min.acc <- round(min(comparison.df$Accuracy),round.to) * 100
max.acc <- round(max(comparison.df$Accuracy),round.to) * 100
min.kap <- round(min(comparison.df$Cohen_Kappa),round.to) 
max.kap <- round(max(comparison.df$Cohen_Kappa),round.to)
}
custom.subtitle <- paste("KNN Atmospheric Weather Model Comparison [k = 4 clusters] | Accuracy (",
                       min.acc, "% , ", max.acc, "% ) | Cohen's Kappa (",
                       min.kap, ", ", max.kap, ")")

ggplot(comparison.df, aes(x = as.factor(Level))) +
  geom_bar(aes(y = Accuracy, fill = "Accuracy"), stat = "identity", alpha = 0.6) +
  geom_bar(aes(y = Cohen_Kappa, fill = "Cohen's Kappa"), stat = "identity", alpha = 0.6) +
  labs(title = "Accuracy and Cohen's Kappa by Level",
       x = "Level",
       y = "Score",
       subtitle = custom.subtitle) +
  scale_y_continuous(limits = c(0, 1)) +
  scale_fill_manual(values = c("Accuracy" = "blue", "Cohen's Kappa" = "red")) +
  scale_x_discrete(labels = function(x) ifelse(x == "0", "225 Boosted", x)) +
  theme_minimal()
