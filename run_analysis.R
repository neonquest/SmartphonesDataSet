## The following function processes the given HAR dataset by doing the following:
## - merge subject, activity(y) and feature(X) values from both the test/train partitions
## - appropriately label the data set with descriptive variable names. 
## - extract only the measurements matching 'features_regex' (mean & std by default)
## - use descriptive activity names to name the activities
## - finally, create a tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
library(reshape2)

run_analysis <- function(topdir = "./UCI HAR Dataset/", features_regex = '\\b(mean|std)\\b') {

    # Read features.txt
    features = read.table(paste(topdir, "features.txt", sep = ""), col.names = c("index", "name"))
    
    # Convert factor vector to character and then to valid column names
    features = as.character(features[,2]) %>% make.names()
    
    # Create a vector of features to be selected based on features_regex
    features_required = features[grepl(features_regex, features, perl = TRUE)]

    # Read data from both test & train partitions
    partitions = c("test", "train")
    all_data = data.frame()
    for (type in partitions) {
        
        subject = read.table(paste(topdir, type, "/subject_", type, ".txt", sep = ""), col.names = "subject")
        y = read.table(paste(topdir, type, "/y_", type, ".txt", sep = ""), col.names = "activity_id")
        
        X = read.table(paste(topdir, type, "/X_", type, ".txt", sep = ""), col.names = features)
        # Keep only the features_required columns  
        X = X[,features_required]
        
        # Combine subject, activity, measurements columns and add this data to all_data
        all_data = rbind(all_data, cbind(subject, y, X))
    }

    # Read activity labels
    activity_labels = read.table(paste(topdir, "activity_labels.txt", sep = ""), col.names = c("activity_id", "activity_label"))
    
    # merge all_data and activity_labels to add descriptive activity names
    # remove activity_id column & rename activity_label column to activity
    all_data = merge(all_data, activity_labels, by.x = "activity_id", by.y = "activity_id") %>% 
               subset(select = -activity_id) %>%
               rename(activity = activity_label)

    # Create a tidy data set with the average of each variable for each activity and each subject.
    mean_data = melt(all_data, id = cbind("subject", "activity")) %>% 
                dcast(subject + activity ~ variable, mean)
    
    mean_data    
}

har_tidydata = run_analysis()
har_tidydata

write.table(har_tidydata, file = "./UCI_HAR_tidydata.txt", row.names = FALSE)
