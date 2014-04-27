library(reshape2)
library(data.table)
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

#Create CodeBook
source("./descriptiveLabelTinyDataset.r")
datanames <- descriptiveLabelTinyDataset("./meanEachVariableBySubjectIDAndActCode.txt")
orig <- paste(paste("* ",datanames$`Original name`))
des <- datanames$`Descriptive name`
write.table(data.table(orig,des,as.character(lapply(filteredData,class))),
            file="Codebook.md",
            quote = FALSE, 
            col.names=FALSE, 
            row.names=FALSE,
            sep=":\t")

#5.Creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject. 
dataMelt <- melt(filteredData,id=c("SubjectID","ActivityCode","Activity"))
meanVariablesBySubjectIDAndActCode  <- dcast(dataMelt, 
                                   SubjectID + ActivityCode + Activity ~ variable,
                                   mean)
names(meanVariablesBySubjectIDAndActCode) <- des
write.csv(meanVariablesBySubjectIDAndActCode
          ,file="./meanEachVariableBySubjectIDAndActCode.csv",row.names=FALSE)

unique(filteredData$ActivityCode)
