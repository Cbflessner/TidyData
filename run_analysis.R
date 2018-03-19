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
mean_col<-grep("[mM]ean()", names(x_full))
std_col<-grep("[sS][tT][dD]()", names(x_full))
all_col<-c(1,2,mean_col,std_col)

##Extract only measurements of mean and standard deviation
mean_std<-x_full[,all_col]

##Label activities
mean_std$activity<-as.factor(mean_std$activity)
mean_std$activity<-ordered(mean_std$activity, levels=c(1,2,3,4,5,6), 
                           labels=c("Walking","Walking Upstairs",
                                    "Walking DownStairs", "Sitting", "Standing", 
                                    "Laying"))


##get the average of each variable grouped by activity and subject
avg<-mean_std%>%group_by(activity,subject)%>%summarise_each(funs(mean))