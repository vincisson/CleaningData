library(dplyr)
library(reshape)
library(reshape2)

#read in all necessary data
act_lab <- read.table("activity_labels.txt", sep=" ")
features <- read.table("features.txt", sep=" ")

subject_train <- read.table("train/subject_train.txt", sep= "")
x_train <- read.table("train/X_train.txt", sep= "")
y_train <- read.table("train/y_train.txt", sep= " ")

subject_test <- read.table("test/subject_test.txt", sep= "")
x_test <- read.table("test/X_test.txt", sep= "")
y_test <- read.table("test/y_test.txt", sep= " ")

#rename the columns according to the different features
colnames(x_train)=features$V2
colnames(x_test)=features$V2

#add a column defining the training subject as well as the training features for each measurement
x_train2 <- cbind(x_train, "subject" = subject_train$V1, "feat" = y_train$V1)
x_test2 <- cbind(x_test, "subject" = subject_test$V1, "feat"= y_test$V1)


#bind the test and the train set together
x_com <- rbind(x_test2, x_train2)


#find the variables that are interesting (mean and standard deviation), keep it as an index, together with the information about the subject and the training feature
index <- c(grep("mean|std", colnames(x_com)), which(colnames(x_com)%in% c("subject","feat", "group")))

#subset the data set according to our index
x_com_sub <- x_com[,index]

#change the activity features into descriptive names
x_com_sub$feat = factor(x_com_sub$feat, labels = act_lab$V2)

#change the variable names into the descriptive variable names
var <- colnames(x_com_sub)[1:79]

#perform a melt depending on each id and feature
melt <- melt(x_com_sub, id=c("subject","feat"), measure.vars = var)

#create a tidy data containing the mean values for each subject/activity. 
x_com_sub_tidy <- dcast(melt, subject+feat ~ var, mean)

write.table(x_com_sub_tidy, file = "tidytable.txt", row.names = FALSE)

