## Getting and Cleaning Data - my Course Project

####My cleanup script run_analysis.R performs the following steps:

* Imports and processes the features, activities and subjects files
* Merges the test and training datasets to create one dataset
* Extracts only the measurements on the mean and standard deviation for each measurement
* Assigns earlier read labels as descriptive activity names
* Creates a second, independent clean dataset with the average of each variable for each activity and each subject
* Writes such clean data to a file as an R table (space-separated text format)

####How to run the script:

Source run_analysis.R and issue RunAnalysis(directory, [output]), where directory points to where your data is stored, and output is the file where it will write the results. If no file is specified, it will default to output.txt. For instance:

> source("run_analysis.R")<br />
> RunAnalysis("UCI HAR Dataset", "UCI.output.txt")

When running the script, you will be shown the following events:

> Importing features...<br />
> Importing activities...<br />
> Importing datasets...<br />
> Processing datasets...<br />
> Calculating averages...<br />
> Saving data to output.txt

####About the procedure:

* Imports all the names of features from features.txt containing either -mean() or -std(). Ignores the rest.
* Imports the levels and names of the activities from activity_labels.txt.
* Imports test and training raw datasets. For each one, do the following:
    * Read the features data file (from X file).
    * Subset this data to drop any columns not in the set of mean or std features as listed in CodeBook.md.
    * Read the activities data file (from Y file).
    * Replace activity levels with proper names from the set of the activities.
    * Read the subjects data file.
    * Every aforementioned data file is appended to a raw dataset as it's read and processed.
* Joins test and training datasets.
* Rearranges the dataset in terms of subject and activity, one feature per column.
* Calculates the mean for each pair of subject and activity.
* Writes it to the output file.

####Output:

The resulting dataset is saved to the file specified by the user (or output.txt, if none provided) in the same directory as the raw data. It contains one row per pair of subject/activity and one column for each feature being either mean or standard deviation as stated in CodeBook.md.
