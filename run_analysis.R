##Loading Libraries
library(dplyr)
library(reshape2)

##Donwload the ZIP folder
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "dataset.zip", method = "auto")

## UNZIP Folder
unzip("dataset.zip")


### Merginng Training and Test datasets

## Reading Files

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## Column Name Assignment

colnames(activityLabels) <- c('ActivityID', 'Activity')

colnames(subject_train) <- "SubID"
colnames(x_train) <- features[,2]
colnames(y_train) <- "ActivityID"
colnames(subject_test) <- "SubID"
colnames(x_test) <- features[,2]
colnames(y_test) <- "ActivityID"

## Creating Sub-Tables

Data_Test <- cbind(y_test, subject_test, x_test)
Data_Train <- cbind(y_train, subject_train, x_train)

## Merging the Datasets

HARecog <- rbind(Data_Test, Data_Train)

## Creating Mean, SD and ID definition vector

M_SD <- (grepl("ActivityID", names(HARecog)) | grepl("SubID", names(HARecog)) | grepl("std()..", names(HARecog)) | grepl("mean()..", names(HARecog)))

## Subsetting Mean and SD from HARecog

Mean_SD_Subset <- HARecog[, M_SD == TRUE]

## Applying Activity descriptive naming

Mean_SD_Subset$ActivityID <- factor(Mean_SD_Subset$ActivityID, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

## Creating Avg. Dataset ordered by Subject

AVG_Dataset <- aggregate(. ~SubID + ActivityID, Mean_SD_Subset, mean)
AVG_Dataset <- AVG_Dataset[order(AVG_Dataset$SubID, AVG_Dataset$ActivityID),]

## Creating a .TXT file.

write.table(AVG_Dataset, "AVG_Dataset.txt", row.name=FALSE)
    

