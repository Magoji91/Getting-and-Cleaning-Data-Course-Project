The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

You should create one R script called run_analysis.R that does the following:

  
I-)Merges the training and the test sets to create one data set.
1.	How to read the arquive: features.txt    
    features<-read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors=F)
    
    
2.	How to read the arquive: activity_labels.txt
    activity_label<-read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)
    
    
3.	How to read the subjects from: the testing and training sets
    testing_subjects<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
    training_subjects<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
    
4.	How to add the subjects from the testing set to the new dataset
    tidy_dataset<-testing_subjects
   
5.	How to add the subjects from the training set to the new dataset
    tidy_dataset<-rbind(tidy_dataset,training_subjects)
    
6.	How to replace the column name to Subjects
    colnames(tidy_dataset)[1]<-"Subjects"  

7.	How to read the activities of the subjects from both the testing and training sets
    
    test_activity<-read.table("./data/UCI HAR Dataset/test/Y_test.txt")
    train_activity<-read.table("./data/UCI HAR Dataset/train/Y_train.txt")
    
    subject_activity<-test_activity ### Adding the testing activity 
    subject_activity<-rbind(subject_activity,train_activity) ### Appending the training activity
    
8.	How to replace the activities by their name from the activity_label dataframe
      for(i in 1:nrow(tidy_dataset)){
      index<-which(activity_label[,1] == subject_activity[i,1])
      tidy_dataset$Activity[i]<-activity_label[index,2]
    }
    
9.	How to read the 561 features readings for each subjects from both the testing and training sets
    test_feature_readings<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
    train_feature_readings<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
   
10.	Adding the features readings of testing
feature_readings<-test_feature_readings

11.	Appending the features readings of training
rbind(feature_readings,train_feature_readings)   
    
12.	Replacing the names of 561 columns with feature readings in the “tidy_dataset”  with their features names from the features dataframe  
    for(i in 1:ncol(feature_readings))
    {
      tidy_dataset<-cbind(tidy_dataset,feature_readings[,i])
      names(tidy_dataset)[ncol(tidy_dataset)]<-features[i,2]
    }
    
  
II-) Extracts only the measurements on the mean and standard deviation for each measurement.
1.	Measuring the mean and standard deviation of the columns 
    extract<-grep("(.*)(mean|std)[Freq]?(.*)[/(/)]$|(.*)(mean|std)(.*)()-[X|Y|Z]$",colnames(tidy_dataset),value=T)    

  
III-) Uses descriptive activity names to name the activities in the data set.
 1.	Sorting the tidy_dataset with the extracted columns
    tidy_dataset<-tidy_dataset[,c("Subjects","Activity",extract)]

  
IV-) Appropriately labels the data set with descriptive variable names.
 1.	REPLACING THE ACTIVITY LABELS WITH DESCRIPTIVE NAMES:
    
    tidy_dataset$Activity<-gsub("WALKING_UPSTAIRS","Walking Up",tidy_dataset$Activity)
    tidy_dataset$Activity<-gsub("WALKING_DOWNSTAIRS","Walking Down",tidy_dataset$Activity)
    tidy_dataset$Activity<-gsub("WALKING","Walking",tidy_dataset$Activity)
    tidy_dataset$Activity<-gsub("SITTING","Sitting",tidy_dataset$Activity)
    tidy_dataset$Activity<-gsub("STANDING","Standing",tidy_dataset$Activity)
    tidy_dataset$Activity<-gsub("LAYING","Laying",tidy_dataset$Activity)
  
 2.	HOW TO REPLACE THE COLUMN NAMES WITH DESCRIPTIVE NAMES: 
A.	Striping the parenthesis from the column names
    colnames(tidy_dataset)<-gsub("[/(/)]","",colnames(tidy_dataset))
    
B.	Striping the hyphens from the column names and replacing it with underscores
    colnames(tidy_dataset)<-gsub("-","_",colnames(tidy_dataset))

V-) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
1.	Check if the data.table package is installed 
2.	Download if not 
3.	Load the package
   
    if(!("data.table" %in% rownames(installed.packages()))){
      
      install.packages("data.table")
      library(data.table)
      
    }else{
      
      library(data.table)
    }
    
4.	Convert the data frame to data table
    tidy_dataset = data.table(tidy_dataset)
    
5. Separate data by subject and activity of each of the subjects to allow the implementation of future calculations
    write.csv(tidy_dataset,"Tidy_Data.csv",row.names=F)
