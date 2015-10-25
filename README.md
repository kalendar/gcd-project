# Introduction

This is the README file for run_analysis.R. This file explains what the script does in order to produce the tidy data required for the project. The steps outlined below align with steps in the comments of the script.

# Step 0. Read in the data
This step simply reads in the subjects, labels, and data from the test and training data sets.

# Step 1: Merge the training and the test sets to create one data set
This step combines the three data sets from test into a dataframe. It then combines the three data sets from train into a dataframe. Finally, these two dataframes are merged into one large dataframe.

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement 
## Find the column numbers we need to extract
This step begins by reading in the features information. It then creates two subsets of the features data, one the string "mean(" and one on the string "std(". These subsets now contain the mean and standard deviations in the data. Finally, these two subsets are combined into one large dataframe and sorted back into their original order, which was lost when the two smaller dataframes were rbinded.    

## Put all the indices from f in a vector, less the first column which we'll use to make the df
Using the results of the previous step, in this step we create a vector of all the column numbers that we need to subset from our larger dataframe, except column 1. We use column one to initialize the new means-only and stds-only dataframe.

## Add the columns that include mean or std info to the dataframe df
Here we add the means and std columns, one at a time, to the new dataframe.

## Add labels to df
Here we add the column of activity labels to the end of the dataframe. 

## Add subjects to df
Here we add the column of subject ID to the end of the dataframe. 

# Step 3: Use descriptive activity names to name the activities in the data set 
In this step we replace the numeric label for each activity with a human readable name for the activity, using information from the activity labels file.

# 4. Appropriately label the data set with descriptive variable names
## Add labels for Activity and Subject ID to f.extra with descriptive variable names
In this step we add the column names for the activity label and subject id to the dataframe we will use to replace the vague column names with descriptive variable names. 

## Sort by the previous row number
Here we make sure to sort the descriptive variables dataframe so it is in the same order as the columns in the larger dataframe.

## Change the column names to the descriptive variable names
Here we actually change the column names with the values in our descriptive variables dataframe.

# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
In this step we loop through the list of subjects, subsetting the data on each subject. Within each subject's subset we subset again on activity type. Within each activity subset, we take the means of the values of each column. The label, subject, activity, and means are then written one row at a time to create the final dataframe. 

Finally, the newly tidy data is written out to a .txt file as per the homework instructions.
