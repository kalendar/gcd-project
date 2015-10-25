library(dplyr)

# Step 0. Read in the data
test.subjects <- read.table("test/subject_test.txt")
test.labels <- read.table("test/y_test.txt")
test.data <- read.table("test/X_test.txt")
train.subjects <- read.table("train/subject_train.txt")
train.labels <- read.table("train/y_train.txt")
train.data <- read.table("train/X_train.txt")

# ===============================
# Step 1: Merge the training and the test sets to create one data set
testdf <- cbind(test.data, test.labels, test.subjects)
traindf <- cbind(train.data, train.labels, train.subjects)
uberdf <- rbind(testdf, traindf)

# ===============================
# Step 2: Extract only the measurements on the mean and standard deviation for each measurement 
## Find the column numbers we need to extract
features <- read.table("features.txt", stringsAsFactors = FALSE)
f.mean <- features[grep("mean\\(", features$V2), ]
f.std  <- features[grep("std\\(", features$V2), ]
uberf <- rbind(f.mean, f.std)
f <- uberf[order(V1),] 

## Put all the indices from f in a vector, less the first column which we'll use to make the df
to.extract <- c(2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 428, 429, 503, 504, 516, 517, 529, 530, 542, 543)
df <-data.frame(uberdf[,1])

## Add the columns that include mean or std info to the dataframe df
for (col in to.extract) {
    df <- cbind(df, uberdf[,col])  
}
## Add labels to df
df <- cbind(df, uberdf[,562])
## Add subjects to df
df <- cbind(df, uberdf[,563])

# =================================
# Step 3: Use descriptive activity names to name the activities in the data set 
activities <- read.table("activity_labels.txt")
df$`uberdf[, 562]`[df$`uberdf[, 562]`==1] <- "WALKING"
df$`uberdf[, 562]`[df$`uberdf[, 562]`==2] <- "WALKING_UPSTAIRS"
df$`uberdf[, 562]`[df$`uberdf[, 562]`==3] <- "WALKING_DOWNSTAIRS"
df$`uberdf[, 562]`[df$`uberdf[, 562]`==4] <- "SITTING"
df$`uberdf[, 562]`[df$`uberdf[, 562]`==5] <- "STANDING"
df$`uberdf[, 562]`[df$`uberdf[, 562]`==6] <- "LAYING"

# ================================
# 4. Appropriately label the data set with descriptive variable names

## Add labels for Activity and Subject ID to f.extra with descriptive variable names
f.extra <- uberf
temp <- list(562, "Activity")
f.extra <- rbind(f.extra, temp)
temp <- list(563, "Subject ID")
f.extra <- rbind(f.extra, temp)
## Sort by the previous row number
f.extra <- f.extra[order(f.extra$V1), ]

## Change the column names to the descriptive variable names
colnames(df) <- as.character(f.extra$V2)

# ================================
# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
## Initialize some variables we'll use below
subj <- c()
actv <- c()
avg <- c()
lbl <- c()
variable <- character()
average <- numeric()
activity <- character()
subject <- integer()
options(stringsAsFactors = FALSE)
finaldf <- data.frame(variable, average, activity, subject)

## Subset data by subject, then activity, then take averages by column and add rows to the finaldf
for (subject in 1:29) {
    tempdf1 <- df[df$`Subject ID`==subject, ]
      for (activity in unique(tempdf1$Activity)) {
        tempdf2 <- tempdf1[tempdf1$Activity==activity, ]
              for (i in 1:66) {
              avg[i] <- mean(tempdf2[[i]])
              subj[i] <- subject
              actv[i] <- activity
              lbl[i] <- colnames(tempdf2[i])
              finaldf <- rbind(finaldf, list(variable=lbl[i], average=avg[i], activity=actv[i], subject=subj[i]))
              }
          } 
    }

write.table(finaldf, file="finaldf.txt", row.name=FALSE)
