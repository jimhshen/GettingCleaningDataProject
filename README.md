# Getting and Cleaning Data Course Project

The R script ('run_analysis.R') does the following:

1. Loads required packages
2. Gets the data file, creating a folder in the current working directory
3. Loads the training, test, and features data from the data folder
4. Merges the data into one dataset
5. Subsets the data to only the variables that measure mean and standard deviation
6. Uses the activity labels file to replace the activity names
7. Generates descriptive variable names for the data
8. Aggregates the data into the mean of each variable by subject and activity
9. Outputs the tidy dataset as 'dataTidy.txt'
