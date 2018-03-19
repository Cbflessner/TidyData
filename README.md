# TidyData

This scipt must be run from the same working directory as the UCI HAR Dataset.  It accepts as inputs the different test and train files within that diretory and outputs a tidy data set that includes only columns which calculated a mean or standard deviation in that experiment.  It then calculates a mean for all of these columns grouped by the activity and subject.  This new summarized data is stored in the variable avg.
