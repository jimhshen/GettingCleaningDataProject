#Load required packages
packages = c("data.table", "plyr", "knitr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

#Set URL, working directory
fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file = "Dataset.zip"
path=getwd()

#Download file and put in data folder
if (!file.exists("./data")) {dir.create("./data")}
download.file(fileurl, file.path(path, file))

#Extract the file
unzip(zipfile="./Dataset.zip",exdir="./data")

#Set File Location
fileLocation <- file.path("./data", "UCI HAR Dataset")

#Get data
dataSubjectTrain <- fread(file.path(fileLocation, "train", "subject_train.txt"))
dataSubjectTest  <- fread(file.path(fileLocation, "test" , "subject_test.txt" ))

dataActivityTrain <- fread(file.path(fileLocation, "train", "Y_train.txt"))
dataActivityTest  <- fread(file.path(fileLocation, "test" , "Y_test.txt" ))

tableTrain <- read.table(file.patdatah(fileLocation, "train", "X_train.txt"))
tableTest <- read.table(file.path(fileLocation, "test" , "X_test.txt" ))
dataFeaturesTrain <-data.table(tableTrain)
dataFeaturesTest <-data.table(tableTest)

#Merges the training and the test sets to create one data set
#Concatenate and name data tables
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(dataSubject, "V1", "subject")

dataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(dataActivity, "V1", "activity")

dataFeat<- rbind(dataFeaturesTrain, dataFeaturesTest)
featuresNames <- fread(file.path(fileLocation, "features.txt"))
names(dataFeatures) <- featuresNames$V2

#Merge columns into one dataset
dataMerged <- cbind(dataSubject, dataActivity)
data <- cbind(dataMerged, dataFeatures)


#Extracts only the measurements on the mean and standard deviation for each measurement
#Get subset of variables with "mean" and "standard deviation"
meanstd<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]

#Keep measurements on means and standard deviations
keepNames<-c( "subject", "activity", as.character(meanstd))
data<-subset(data,select=keepNames)

#Uses descriptive activity names to name the activities in the data set
#Use activity labels file to replace numeric activity
activityLabels <- read.table(file.path(fileLocation, "activity_labels.txt"), header = FALSE)
activityLabels <- as.character(activityLabels[,2])
data$activity <- activityLabels[data$activity]

#Appropriately labels the data set with descriptive variable names
#Replace labels with descriptive variable names
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("std", "StdDev", names(data))
names(data)<-gsub("mean", "Mean", names(data))
names(data)<-gsub("\\(\\)", "", names(data))
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))

#Creates a second, independent tidy data set with the average
#of each variable for each activity and each subject.
data<-data.frame(data)
dataTidy<-aggregate(data[,3:68], by = list(subject = data$subject, activity = data$activity),FUN = mean)

write.table(dataTidy, file = "dataTidy.txt",row.name=FALSE)