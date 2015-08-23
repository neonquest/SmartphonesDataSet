library(dplyr)
library(reshape2)

# Merge the training and the test sets to create one data set.
# Extract only the measurements on the mean and standard deviation for each measurement.
# Appropriately label the data set with descriptive variable names. 
run_analysis <- function(topdir = "./UCI HAR Dataset/", inputs = c("test", "train"), features_regex = 'mean|std') {

    # Read features.txt
    features = read.table(paste(topdir, "features.txt", sep = ""), col.names = c("index", "name"))
    
    # Convert factor vector to character and to valid column names
    features = as.character(features[,2]) %>% make.names()
    
    # Filter features to be selected and convert to valid column names
    features_required = features[grepl(paste("\\b(", features_regex, ")\\b", sep = "") , features, perl = TRUE)]
    
    all_data = data.frame()
    for (type in inputs) {
        
        subject = read.table(paste(topdir, type, "/subject_", type, ".txt", sep = ""), col.names = "subject")
        y = read.table(paste(topdir, type, "/y_", type, ".txt", sep = ""), col.names = "activity_id")
        
        X = read.table(paste(topdir, type, "/X_", type, ".txt", sep = ""), col.names = features)
        X = X[,features_required]
        
        all_data = rbind(all_data, cbind(subject, y, X))
    }

    # Use descriptive activity names to name the activities
    activity_labels = read.table(paste(topdir, "activity_labels.txt", sep = ""), col.names = c("activity_id", "activity_label"))
    
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
