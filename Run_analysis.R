The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

You should create one R script called run_analysis.R that does the following:

  
I-) Merges the training and the test sets to create one data set.
    PROCEDURE:
1.DOWNLOAD AND UNZIP the arquive: 
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/projectData_getCleanData.zip")
listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")
      
2.LOAD THE DATA
train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")  

3.CREATE ONE DATA SET
trainData <- cbind(train.subject, train.y, train.x)
testData <- cbind(test.subject, test.y, test.x)
fullData <- rbind(trainData, testData) 
  
II-) Extracts only the measurements on the mean and standard deviation for each measurement.
    PROCEDURE:          
1.Load feature names
featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
   
2. Measure the mean and standard deviation of the columns 
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
Cleandata <- fullData[, c(1, 2, featureIndex+2)]
colnames(Cleandata) <- c("subject", "activity", featureName[featureIndex]) 
    
III-) Uses descriptive activity names to name the activities in the data set.
    PROCEDURE:
1.	Load activities data
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

2. Replace 1 to 6 with activity names
Cleandata$activity <- factor(Cleandata$activity, levels = activityName[,1], labels = activityName[,2])
  
IV-) Appropriately labels the data set with descriptive variable names.
    PROCEDURE:
1.	REPLACE THE ACTIVITY LABELS WITH DESCRIPTIVE NAMES:
names(Cleandata) <- gsub("\\()", "", names(Cleandata))
names(Cleandata) <- gsub("^t", "time", names(Cleandata))
names(Cleandata) <- gsub("^f", "frequence", names(Cleandata))
names(Cleandata) <- gsub("-mean", "Mean", names(Cleandata))
names(Cleandata) <- gsub("-std", "Std", names(Cleandata))
    
V-) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    PROCEDURE:
1.	Check if the dplyr package is installed 
2.	Download if not 
3.	Load the package
   
    if(!("dplyr" %in% rownames(installed.packages()))){
      
      install.packages("dplyr")
      library(data.table)
      
    }else{
      
      library(dplyr)
    }
    
groupData <- Cleandata %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

write.table(groupData,row.name = FALSE,file = "Cleandata.txt")
