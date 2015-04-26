---
title: "README.md"
author: "S. Blackstone"
date: "Saturday, April 25, 2015"
output: html_document
---
## Contents of this repository

groupedmeansdataset.txt

:    The dataset produced in the course project for the Coursera course "Getting and Cleaning the Data"

CodeBook.md

:    The code book for this dataset

xrun_analysis.R

:    The script containing the R code to create the dataset

README.md

:    This file


## Description of the run_analysis.R script

The script performs the following tasks

1. Merges the training and the test sets to one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each varfiable for each activity and each subject.

### Assumptions
The script assumes that the zipfile "UCI HAR Dataset.zip" is unpacked and that the script is run with the working directory set to the "UCI HAR Dataset" folder. That folder then contains two subfolders "train" and "test", containing the training and test datasets, respectively.

### Script Walkthrough
Roughly speaking the steps in the script are as follows:

1. Read all the data into data tables in memory
2. Set column names for the x data tables
3. Select only those columns where the names end in either 'mean()' or 'std()'
4. Add the Activity column frmo the y train table to the x train table, do the same for the corresponding test tables, and then merge the two tables to one data set.
5. Create the second data set with the average values
6. Save the data set to a file

#### **Data Input**
Lines 4 to 11 in the script read all relevant data files into memory with the `read.table` function.
```{r}
read.table("train/X_train.txt")       -> xtrain
read.table("train/Y_train.txt")       -> ytrain
read.table("train/subject_train.txt") -> strain
read.table("features.txt")            -> featurenames
read.table("activity_labels.txt")     -> activities
read.table("test/X_test.txt")         -> xtest
read.table("test/Y_test.txt")         -> ytest
read.table("test/subject_test.txt")   -> stest
```

#### **Column Naming and Selection**
In the next couple of lines the column names of the tables `xtrain` and `ytrain` are set to their corresponding names in the `featurenames` table. The name 'Acitivy' is chosen for the label of the y column; thois is done in the activities table (and joined to the resulting merged table in a later stage)


```{r}
colnames(xtrain) <- featurenames$V2
colnames(xtest)  <- featurenames$V2

activities <- rename(activities,Activity=V2)
```

Next step is to select only those (task 2 from the assignment). Only columns with names that end in 'mean()' or 'std()' are selected, using the `grep()` function. The result is stored in intermediate variables `xtrainm` and `xtestm`.

```{r}
featurenames[grepl("(mean|std)\\(\\)",featurenames$V2),] -> meanstdfeatures

xtrain[,meanstdfeatures$V1] -> xtrainm
xtest[,meanstdfeatures$V1]  -> xtestm
```

#### **Combining the data tables into one**
Chaining is used to combine the different tables to form one new table.  

We start with the intermediate `xtrainm` table
```{r}
mergedDataSet <- xtrainm %>%
```
and add column named "Set", containing only the (factor) value "TRAINING". This column is used to be able to distinguish between data originating from the original training cq test data sets.
```{r}
  cbind(Set=rep(as.factor("TRAINING"),nrow(xtrainm))) %>%
```
Next a column containing the subject information is added,
```{r}  
  cbind(Subject=strain$V1) %>% 
```
followed by a column with the activity from the y data set, with the numeric values replaced by the human-readable labels for the activities from the `activities` table. Replacement of numeric values by meaningful labels is done by joining the `ytrain` and `activities` tables and taking the `Activity` column from the result.
```{r}
  cbind(Activity = 
          (ytrain %>%
             inner_join(activities) %>%
             select(Activity))) %>% 
```
The same procedure is applied for the test data sets, and appended to the result of the previous step using `rbind()`.
```{r}
  rbind(
    xtestm %>%
      cbind(Set=rep(as.factor("TEST"),nrow(xtestm))) %>%  
      cbind(Subject=stest$V1) %>% 
      cbind(Activity = 
              (ytest %>%
                 inner_join(activities) %>%
                 select(Activity))) 
    ) %>% 
```
The last step in the process consists of reordering the columns so that the columns "Set","Subject" and "Activity" appear in the front, before all the measurement data. 
```{r}
    (function (ds) {
      nc <- ncol(ds)
      select(ds, Set, Subject, Activity, 1:(nc-3))
    })
```

#### **Creation of the second table**
The second dataset should contain data from the merged data set containing averages of each variable for each subject and activity. Again, chaining from the dplyr library is used to accomplish this.

Start with the `mergedDataSet` that was the result from the previous steps.
```{r}
groupedmeansDataSet <- mergedDataSet %>%
```
and group the data by Subject and Activity using the `group_by()` function.
```{r}
  group_by(Subject, Activity) %>%
```
Finally, summarise using `mean` for all measurements columns. These are all columns except the first 3. Because the data is grouped by Activity and Subject, only the Set column needs to be excluded.
```{r}
  summarise_each(funs(mean),-matches("Set"))
```

Finally, because the meaning of the columns in this dataset is no longer the same as in the intermediate dataset (columns contain averages of values rather than the actual values), the column names (except for the group columns) have been renamed, by prefixing all but the two first columns with "m_" (indicating mean, see code book).

```{r}
colnames(groupedmeansDataSet) <- 
  c(colnames(groupedmeansDataSet)[1:2],
    paste("m_",colnames(groupedmeansDataSet)[-(1:2)],sep=""))
```

This data set was saved to the file 'groupedmeansdataset.txt' with the command
```{r}
write.table(groupedmeansDataSet,file="groupedmeansdataset.txt",row.names=FALSE)
```
