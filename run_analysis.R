library(dplyr)

# Merge the training and the test sets to create one data set.
# Extract only the measurements on the mean and standard deviation for each measurement.
# Appropriately label the data set with descriptive variable names. 
read_data <- function(topdir = "./data/UCI HAR Dataset/", inputs = c("test", "train"), features_regex = 'mean|std') {
    
    features_regex = 'mean|std'
    # Read features.txt
    features = read.table(paste(topdir, "features.txt", sep = ""), col.names = c("index", "name"))
    
    # Convert factor vector to character and to valid column names
    features = as.character(features[,2]) %>% make.names()
    
    # Filter features to be selected and convert to valid column names
    features_required = features[grepl(paste("\\b(", features_regex, ")\\b", sep = "") , features, perl = TRUE)]
    
    all_data = data.frame()
    for (type in inputs) {
        
        subject = read.table(paste(topdir, type, "/subject_", type, ".txt", sep = ""), col.names = "subject")
        y = read.table(paste(topdir, type, "/y_", type, ".txt", sep = ""), col.names = "activity")
        
        X = read.table(paste(topdir, type, "/X_", type, ".txt", sep = ""), col.names = features)
        X = X[,features_required]
        
        all_data = rbind(all_data, cbind(subject, X, y))
    }
    names(all_data)

    # Use descriptive activity names to name the activities in the data set
    activity_labels = read.table(paste(topdir, "activity_labels.txt", sep = ""), col.names = c("id", "label"))
    
    all_data
}

data = read_data()



# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



