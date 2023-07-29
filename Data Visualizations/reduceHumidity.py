import pandas as pd

# Step 1: Read the dataset from Excel into a DataFrame
df = pd.read_excel('master_atmospheric_dataset_Lomicka.xlsx')

# Step 2: Remove even-indexed rows
df_cleaned = df.iloc[1::2]  # Slice the DataFrame, starting from the second row, and keep every other row

# Step 3: Save the cleaned DataFrame to a new CSV file
df_cleaned.to_csv('master_cleaned_atmospheric.csv', index=False)  # We don't need to save the index column

print("Cleaning and saving complete.")
