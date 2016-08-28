setwd("SET YOUR PATH HERE")

# Read features and activity type
features <- read.csv("UCI HAR Dataset/features.txt", sep = "", header=FALSE)
activitylabels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header=FALSE)

# Read test data
xtest <- read.csv("UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
ytest <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header=FALSE)
subjecttest <- read.csv("UCI HAR Dataset/test/subject_test.txt",sep="", header=FALSE)

# Read train data
xtrain <- read.csv("UCI HAR Dataset/train/X_train.txt",sep="", header=FALSE)
ytrain <- read.csv("UCI HAR Dataset/train/y_train.txt",sep="", header=FALSE)
subjecttrain <- read.csv("UCI HAR Dataset/train/subject_train.txt",sep="", header=FALSE)

# Assign column names based on features (test)
colnames(xtest) <- features[,2]
colnames(subjecttest)  <- "SubjectId"
colnames(ytest) <- 'ActivityId'

# Assign column names based on features (train)
colnames(xtrain) <- features[,2]
colnames(subjecttrain)  <- "SubjectId"
colnames(ytrain) <- 'ActivityId'

# Create complete testing set (merge xtest, ytest and subjecttest)
test_set <- cbind(xtest, ytest, subjecttest)

# Create complete training set (merge xtrain, ytrain and subjecttrain)
train_set <- cbind(xtrain, ytrain, subjecttrain)

# Merge training and testing sets
completedata <- rbind(test_set, train_set)

# Extract the following measurements: mean and standard deviation to a new dataframe called 'datameanstd'
measurements <- c("SubjectId", "ActivityId", "mean", "std")
datameanstd <- completedata[,grep(paste(measurements, collapse = '|'), names(completedata),ignore.case=TRUE)]

# Name activities in dataset according to activitylabels
colnames(activitylabels) <- c('ActivityId', 'ActivityLabel')
datameanstd <- merge(datameanstd, activitylabels , by='ActivityId',all.x=TRUE)

# Rename variable
colnames(datameanstd) <- gsub("\\()","",colnames(datameanstd))
colnames(datameanstd) <- gsub("^f","Freq",colnames(datameanstd))
colnames(datameanstd) <- gsub("^t","Time",colnames(datameanstd))
colnames(datameanstd) <- gsub("-mean", "Mean", colnames(datameanstd))
colnames(datameanstd) <- gsub("-std", "StdDev", colnames(datameanstd))
colnames(datameanstd) <- gsub("BodyAcc", "BodyAcceleration", colnames(datameanstd))
colnames(datameanstd) <- gsub("GravityAcc", "GravityAcceleration", colnames(datameanstd))
colnames(datameanstd) <- gsub("Mag", "Magnitude", colnames(datameanstd))

# Get average for each variable, according to activity and subject
activitysubjectmean <- aggregate(.~ActivityLabel+SubjectId, data=datameanstd, mean)

# Export activitysubjectmean dataframe
write.table(activitysubjectmean, '/Users/anabarbosa/Documents/CourseraDataScienceSpecialization/GettingAndCleaningData/tidyData.txt',row.names=FALSE,sep=',')


