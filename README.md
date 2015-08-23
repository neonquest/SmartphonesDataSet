# SmartphonesDataSet

This repository contains the script run_analysis.R which processes the UCI HAR dataset by doing the following:
- merge subject, activity(y) and feature(X) values from both the test/train partitions
- appropriately label the data set with descriptive variable names.
- extract only the measurements matching 'features_regex' (mean & std by default)
- use descriptive activity names to name the activities
- finally, create a tidy data set with the average of each variable for each activity and each subject.

## Input Dataset

The UCI HAR data represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here is the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Output Dataset

Below is a brief description of the variables in the output dataset.

* subject (1) - identifies the subject who performed the activity. Its range is from 1 to 30.
* activity (2)  - identifies the activity performed by the subject. Its value is one of six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) druring which measurements were taken.
* others (3-68) - each of the remaining 66 columns represent the average of all measurements of a specific features, from a specific subject and an activity. These columns directly map to a specific feature measurement (mean or standard deviation only) in the input dataset. See *features_info.txt* for more details. For example, *tBodyAcc.mean...X* column is the mean of all *tBodyAcc-mean()-X* measurements for a given subject and activity. 

The complete list of columns in output dataset are listed in *columns.txt*

See *features_info.txt* details about the features in the input dataset. 
