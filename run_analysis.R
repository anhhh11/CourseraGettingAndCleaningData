library(reshape2)
library(sqldf)
setwd("~//..//Downloads//DSCoursera//cleaningData//UCI HAR Dataset/")
#Read test set
test <- cbind(fread("test/subject_test.txt",header=FALSE),
              fread("test//y_test.txt"),
              data.table(read.table("test//X_test.txt",header=FALSE)))

#Read train set
train <- cbind(fread("train/subject_train.txt",header=FALSE),
               fread("train//y_train.txt"),
               data.table(read.table("train//X_train.txt",header=FALSE)))

#1.Merges the training and the test sets to create one data set.
data <- rbind(test,train)

#Set columns' names to data
featuresNames <- fread("features.txt",header=FALSE)[,V2]
setnames(data,old=1:ncol(data),new=c("SubjectID","ActivityCode",featuresNames))

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
filteredData <- data[,grep("SubjectID|Activity|(mean|std)",names(data))
                   ,with=FALSE]
names(filteredData)

#3,4?.Uses descriptive activity names to name the activities in the data set
activitiesLabel  <- fread("./activity_labels.txt",sep=" ",header=FALSE)
setnames(activitiesLabel,c(1:2),c("ActivityCode","Activity"))
#Join filteredData table to actitivitesLabel table
filteredData <- merge(x=filteredData,y=activitiesLabel
                      ,by=c("ActivityCode"))[,c(1,2,82,3:81),with=FALSE]

#Creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject. 
dataMelt <- melt(filteredData,id=c("SubjectID","ActivityCode","Activity"))
meanVariablesBySubjectIDAndActCode  <- dcast(dataMelt, 
                                   SubjectID + ActivityCode + Activity ~ variable,
                                   mean)
write.csv(meanVariablesBySubjectIDAndActCode
          ,file="./meanEachVariableBySubjectIDAndActCode.csv",row.names=FALSE)
#Or using aggregate
#meanVariablesBySubjectID1 <- aggregate(.~SubjectID+ActivityCode+Activity, data=filteredData,mean)
#meanVariablesBySubjectID1 <- arrange(meanVariablesBySubjectID1,SubjectID,ActivityCode,Activity)

data(iris)
datanames <- names(iris)
outputlines <- paste("* ",datanames , sep="")
write.table(outputlines,file="listofnames.md", quote = FALSE, col.names=FALSE, row.names=FALSE)


#Criteria
# The explanation is as important as the script, so make sure you have the readme
#(x) have you combined the training and test x and y into one block, given them headings, and turned the numeric activities into something easier to read.
#(x) have you extracted some variables to do with mean and standard deviation from the full set
#() have you explained what those variables are and your criteria for picking them in the readme
#() have you gotten the average of each variable for each combination of subject and activity and saved the data frame of this as a set of tidy data
# have you loaded up your current script, an up to date readme! and your tidy data
