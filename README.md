# README
==============================
Tiny data set which derived from UCI HAR Dataset
## Files list and their description:
- README.md
- run_analysis.R: Generate tiny data from raw dataset (UCI HAR Dataset)
- descriptiveLabelTinyDataset.r: Generate descriptive name from raw name of features in tiny dataset
- Codebook.md: Detail for each variable in tiny dataset ( 1st column: column name, 2nd column: column description, 3st column: column value's type)
## Steps for converting raw data to tiny dataset
With data picked from UCI HAR Dataset, I processed as the following:
1. Merges the training and the test sets to create one data set. (Using test/subject_test.txt, test/y_test.txt, train/subject_train.txt, train/y_train.txt)
2. Assign columns name to features (Using features.txt) and then merged table two first columns are SubjectID,ActivityCode
3. Extracts only the measurements on the mean and standard deviation for each measurement. (From merged table, choosing columns match regrex pattern "SubjectID|Activity|(mean|std)"
3. Replace activity's code by activity's name for whole data set.
4. Creates a second, independent tidy data set with the average of each variable for each activity and each subject:
   - Group data by SubjectID, ActivityCode, Activity (Using melt and dcast function from reshape2 library)
   - Apply mean for each grouped variable 
5. Use descriptiveLabelTinyDataset.r (using gsub multiple time) to create descriptive label for dataset