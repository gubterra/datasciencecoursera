# Getting and Cleaning Data Course Project Script Analysis

# set working directory
setwd("C:/Users/Gu-Work/Desktop/repos/datasciencecoursera/Course-3/project")

# load libraries
library(reshape)
library(plyr)


# load train data files into variables
xTrain = read.table("./train/X_train.txt")
yTrain = read.table("./train/y_train.txt")
subjectTrain = read.table("./train/subject_train.txt")

# load test data files into variables
xTest = read.table("./test/X_test.txt")
yTest = read.table("./test/y_test.txt")
subjectTest = read.table("./test/subject_test.txt")

# load headings from file
featuresdf = read.table("./features.txt")
headings = featuresdf$V2

# transfer headings to data set
colnames(xTrain) = headings
colnames(xTest) = headings

# change V1 variable to something descriptive "activity"
yTest <- rename(yTest, c(V1="activity"))
yTrain <- rename(yTrain, c(V1="activity"))

# modify values in yTest according to activity_labels.txt 
activitydf  = read.table("./activity_labels.txt")

# set variable names to lowercase
activityLabels = tolower(levels(activitydf$V2))

# set an factor to variables 
yTrain$activity = factor(
  yTrain$activity, 
  labels = activityLabels
)

yTest$activity = factor(
  yTest$activity, 
  labels = activityLabels
)

# modify variable name to a more descriptive one
subjectTrain <- rename(subjectTrain, c(V1="subjectid"))
subjectTest <- rename(subjectTest, c(V1="subjectid"))

# combine training and test sets 
train = cbind(xTrain, subjectTrain, yTrain)
test = cbind(xTest, subjectTest, yTest)
fullData = rbind(train, test)

# apply pattern
pattern = "mean|std|subjectid|activity"
tidyData = fullData[,grep(pattern , names(fullData), value=TRUE)]

# clean variable names to remove parentheses, dash and commas
cleanNames = gsub("\\(|\\)|-|,", "", names(tidyData))
names(tidyData) <- tolower(cleanNames)

# summarize data
result = ddply(tidyData, .(activity, subjectid), numcolwise(mean))

# write output file
write.table(result, file="tdata.txt", sep = "\t", append=F)


