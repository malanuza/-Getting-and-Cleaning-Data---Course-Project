# MAP's Getting and Cleaning Data Course Project
#
# Please download data from the following location:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# ...and extract it to your preferred location. Please provide it as an argument to run.analysis()

# Builds a file name
BuildDatasetFileName <- function(dataset, name) {
  file.path(dataset, paste0(name, "_", dataset, ".txt", sep=""))
}

# Imports a file with defined column names and possibly a filter
ImportFile <- function(dir, name, names=c("id", "labels"), matches=NA) {

  # Read file as table
  filename <- file.path(dir, name)
  data <- read.table(filename, stringsAsFactors=FALSE)
  
  # Assign column names
  if(all(!is.na(names))) {
    names(data) <- names
  }
  
  # Restrict the returned data to the partial matches on the second column, if any specified
  if(all(!is.na(matches))) {
    data <- data[grep(matches, features[, 2]), ]
  }

  # Return read data
  data
}

# Imports a dataset
ImportDataset <- function(dir, dataset, features, activities) {

  # Import features data. Drop any columns not in the features list
  filename <- BuildDatasetFileName(dataset, "X")
  data <- ImportFile(dir, filename, names=NA)
  dData <- data[, features$id]
  names(dData) <- features$labels
  
  # Import the list of activities. Numeric levels must be replaced with labels
  filename <- BuildDatasetFileName(dataset, "y")
  data <- ImportFile(dir, filename, c("activity"))
  data$activity <- factor(data$activity, levels=activities$id, labels=activities$labels)
  dData <- cbind(dData, data)
  
  # Import the list of subjects
  filename <- BuildDatasetFileName(dataset, "subject")
  data <- ImportFile(dir, filename, c("subject"))
  dData <- cbind(dData, subject = data$subject)
  
  # Return the constructed dataset
  dData
}

# Run analysis on the data under the directory where the downloaded data was extracted
RunAnalysis <- function(dir, name="output.txt") {

  library(reshape2)

  # Import feature labels
  cat("Importing features...\n")
  features <- ImportFile(dir, "features.txt", matches="-mean\\(\\)|-std\\(\\)")
  
  # Import activity labels
  cat("Importing activities...\n")
  activities <- ImportFile(dir, "activity_labels.txt")
  
  # Import all datasets
  cat("Importing datasets...\n")
  rawTest <- ImportDataset(dir, "test", features=features, activities=activities)
  rawTraining <- ImportDataset(dir, "train", features=features, activities=activities)
  
  # Join all datasets and rearrange in terms of subject and activity
  cat("Processing datasets...\n")
  rawData <- rbind(rawTest, rawTraining)
  rawData <- melt(rawData, id.vars=c("subject", "activity"), variable.name="feature")
  
  # Calculate averages
  cat("Calculating averages...\n")
  cleanData <- dcast(rawData, subject + activity ~ feature, mean)
  
  # Save data
  cat("Saving data to", name, "\n")
  filename <- file.path(dir, name)
  write.table(cleanData, filename, row.names=FALSE, quote=FALSE)
  
}
