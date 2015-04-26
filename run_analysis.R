# Load dplyr library for last operations
library(dplyr)

# Load the activities and measures labels
activityLabels <- read.table('UCI HAR Dataset/activity_labels.txt', stringsAsFactors=FALSE, col.names=c('id', 'Activity'))
measureLabels <- read.table('UCI HAR Dataset/features.txt', stringsAsFactors=FALSE)

# Load raw data, activities, and subjects for 'Test' set
testData <- read.table('UCI HAR Dataset/test/X_test.txt', sep='', stringsAsFactors=FALSE, col.names=measureLabels[,2])
testActivities <- read.table('UCI HAR Dataset/test/y_test.txt', sep='', colClasses=c('factor'), col.names=c('id'))
testSubjects <- read.table('UCI HAR Dataset/test/subject_test.txt', sep='', colClasses=c('factor'), col.names=c('Subject'))
# Label activities and add to data set
levels(testActivities$id) <- activityLabels$Activity
testData$Activity <- testActivities$id
# Add subjects to data set
testData$Subject <- testSubjects$Subject

# Load raw data, activities, and subjects for 'Train' set
trainData <- read.table('UCI HAR Dataset/train/x_train.txt', sep='', stringsAsFactors=FALSE, col.names=measureLabels[,2])
trainActivities <- read.table('UCI HAR Dataset/train/y_train.txt', sep='', colClasses=c('factor'), col.names=c('id'))
trainSubjects <- read.table('UCI HAR Dataset/train/subject_train.txt', sep='', colClasses=c('factor'), col.names=c('Subject'))
# Label activities and add to data set
levels(trainActivities$id) <- activityLabels$Activity
trainData$Activity <- trainActivities$id
# Add subjects to data set
trainData$Subject <- trainSubjects$Subject

# Combine the 'Test' and 'Train' data into a unique data set
allData <- rbind(testData, trainData)

# Get the mean and standard deviation column names
meanMeasures <- grep('mean.', names(allData), value=TRUE, ignore.case=TRUE)
stdMeasures <- grep('std', names(allData), value=TRUE, ignore.case=TRUE)
# Filter data to relevant columns
filteredData <- allData[, c(meanMeasures, stdMeasures, 'Activity', 'Subject')]

# Group by Subject, Activity, and calculate the means for each combination
groupedData <- group_by(filteredData, Subject, Activity)
averagesDataSet <- summarise_each_(groupedData, 'mean', c(meanMeasures, stdMeasures))

# Write the last data set to a file
write.table(averagesDataSet, 'averagesDataSet.txt', row.names=FALSE)