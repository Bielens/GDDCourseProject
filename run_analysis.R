## See README.md for asn explanation of this script

library(dplyr)

## READ DATA
read.table("train/X_train.txt")       -> xtrain
read.table("train/Y_train.txt")       -> ytrain
read.table("train/subject_train.txt") -> strain
read.table("features.txt")            -> featurenames
read.table("activity_labels.txt")     -> activities
read.table("test/X_test.txt")         -> xtest
read.table("test/Y_test.txt")         -> ytest
read.table("test/subject_test.txt")   -> stest

## Train and Test datasets columnnames: use the names of the features
colnames(xtrain) <- featurenames$V2
colnames(xtest)  <- featurenames$V2

activities <- rename(activities,Activity=V2)

## columnnames that are mean or std
featurenames[grepl("(mean|std)\\(\\)",featurenames$V2),] -> meanstdfeatures

## for x tables: select only the columns that represent mean or std values 
xtrain[,meanstdfeatures$V1] -> xtrainm
xtest[,meanstdfeatures$V1]  -> xtestm

mergedDataSet <- xtrainm %>%
  cbind(Set=rep(as.factor("TRAINING"),nrow(xtrainm))) %>%  
  cbind(Subject=strain$V1) %>% 
  cbind(Activity = 
          (ytrain %>%
             inner_join(activities) %>%
             select(Activity))) %>% 
  rbind(
    xtestm %>%
      cbind(Set=rep(as.factor("TEST"),nrow(xtestm))) %>%  
      cbind(Subject=stest$V1) %>% 
      cbind(Activity = 
              (ytest %>%
                 inner_join(activities) %>%
                 select(Activity))) 
    ) %>% (function (ds) {
      nc <- ncol(ds)
      select(ds, Set, Subject, Activity, 1:(nc-3))
    })
  
groupedmeansDataSet <- mergedDataSet %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean),-matches("Subject"))


## Meaning of the columns have changed, modify column names accordingly
colnames(groupedmeansDataSet) <- 
  c(colnames(groupedmeansDataSet)[1:2],
    paste("m_",colnames(groupedmeansDataSet)[-(1:2)],sep=""))


## Write result to file
write.table(groupedmeansDataSet,file="groupedmeansdataset.txt",row.names=FALSE)

