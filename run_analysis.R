##load necessary libraries
library(dplyr)

##Get the test data into R.  
## This assumes the user's working directory is /UCI HAR Dataset: 

x_test<-read.table("test/X_test.txt")
act_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")


##Get the train data into R.  
## This assumes the user's working directory is /UCI HAR Dataset:

x_train<-read.table("train/X_train.txt")
act_train<-read.table("train/y_train.txt")
subject_train<-read.table("train/subject_train.txt")

##load in feature names
features<-read.table("features.txt")

##label data
names(x_test)<-features[,2]
names(x_train)<-features[,2]

##Combine all test data
x_test<-cbind(act_test,subject_test,x_test)

##Combine all train data
x_train<-cbind(act_train, subject_train, x_train)

##combind data sets
x_full<-rbind(x_test, x_train)

##rename two new rows
colnames(x_full)[c(1,2)]<-c("activity","subject")

##get the columns that relate to means and standard deviations
mean_col<-grep("mean\\(\\)", names(x_full), ignore.case=TRUE)
std_col<-grep("std\\(\\)", names(x_full), ignore.case=TRUE)
all_col<-c(1,2,mean_col,std_col)

##Extract only measurements of mean and standard deviation
mean_std<-x_full[,all_col]

##Label activities
mean_std$activity<-as.factor(mean_std$activity)
mean_std$activity<-ordered(mean_std$activity, levels=c(1,2,3,4,5,6), 
                           labels=c("Walking","Walking Upstairs",
                                    "Walking DownStairs", "Sitting", "Standing", 
                                    "Laying"))

##make column names more readable
names(mean_std)<-sub("^t", "time_", names(mean_std) )
names(mean_std)<-sub("^f", "frequency_", names(mean_std) )

mean_name<-grep("mean\\(\\)", names(mean_std),ignore.case=TRUE)
names(mean_std)[mean_name]<-paste0("mean_of_", names(mean_std)[mean_name])
names(mean_std)[mean_name]<-sub("-mean\\(\\)", "", names(mean_std)[mean_name])

std_name<-grep("std\\(\\)", names(mean_std),ignore.case=TRUE)
names(mean_std)[std_name]<-paste0("standard_dev_of_", names(mean_std)[std_name])
names(mean_std)[std_name]<-sub("-std\\(\\)", "", names(mean_std)[std_name])

names(mean_std)<-sub("-X", "_in_the_x_direction", names(mean_std))
names(mean_std)<-sub("-Y", "_in_the_y_direction", names(mean_std))
names(mean_std)<-sub("-Z", "_in_the_z_direction", names(mean_std))


##get the average of each variable grouped by activity and subject
avg<-mean_std%>%group_by(activity,subject)%>%summarise_each(funs(mean))