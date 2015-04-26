---
title: "CodeBook"
author: "S. Blackstone"
date: "26 april 2015"
output: html_document
---
## Source
Source for this dataset is the Human Activity Recognition Using Smartphones Dataset Version 1.0. This database was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. More information on how the experiment was setup is given below (quote from 'README.txt' accompanying the original data set) 
 
<pre>
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING,
LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and 
gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 
50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been
randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training
data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then 
sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor 
acceleration signal, which has gravitational and body motion components, was separated using a Butterworth
low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low 
frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector
of features was obtained by calculating variables from the time and frequency domain. 
See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

</pre>

The description of the original 561-feature vector, selection taken from the code book of the original data set: 

<pre>
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals 
tAcc-XYZ and tGyro-XYZ.
</pre>

...

<pre>
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
</pre>

The original data set was split into two parts, a training set and a test set, comprising 70% resp. 30% of the entire set of measurements. The original data set ws delivered as a set of multiple files containing measurements, subjects and activities, for both the training and test parts.

## Operations
**Merge**

From the original dataset the several parts have been merged into one, with one row per observation

**Column selection**

Only columns denoting a mean or std of the measurements have been taken up in this data set

**Aggregation**

For each subject and activity, the mean of the values from the original dataset was taken. The original values are not included in the resulting set. 

**Labeling**

Where in the original data set numbers wer ised to indicate the activity, this dataset uses human readable labels

## Columns

Each observation has values for the following columns:

| Column Name   | Description   | Type  |
| ------------- |------------- |-----|
| Subject       | The subject performing the activity | int: 1-30 |
| Activity      | A label describing the activity performed by the subject |  character: One of LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS |
| m_*featurename* for each of the original features in the feature vector | means of the measurements for the combination of Subject and Activity| numeric 

Exlanation of the m_*featurename* columns is as follows. The original features are listed in the quoted section describing them (tBodyAcc-XYZ to fBodyGyroJerkMag). For each of them there was (among others) a mean() and std() value; the function name was appended to the feature name giving the feature column names, e.g. tBodyAccMag-mean() and tBodyAccMag-mean(). The corresponding columns in this dataset containing the means of these features are named m_tBodyAccMag-mean() and m_tBodyAccMag-std(). Where the original feature name had X,Y, and Z measurements this results in 3 columns for both mean() and std(), e.g. m_tGravityAcc-mean()-X, m_tGravityAcc-mean()-Y, etc. until m_tGravityAcc-std()-Z

