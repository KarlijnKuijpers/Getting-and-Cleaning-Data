#1 	Merges the training and the test sets to create one data set.
#	2	Extracts only the measurements on the mean and standard deviation for each measurement.
#	3	Uses descriptive activity names to name the activities in the data set
# 4	Appropriately labels the data set with descriptive variable names.
#	5	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Install data
	file <- "./Dataset.zip"
	url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(url, file, method="curl" )
	
# Unzip file
	unzip(file)

# List the files
	files <- list.files(path="./UCI HAR Dataset", recursive=TRUE)
	
# Read in files
	IS <- grep("Inertial Signals",files)
	readingFiles <- files[-IS]
	readingFiles <- readingFiles[-c(1,2,3,4)]
		
# Read test
	#activity is "y.."
	#subject is "subject..."
	#data is "x..."
	testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
	testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
	testData <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Read train	
	#activity is "y.."
	#subject is "subject..."
	#data is "x..."
	trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
	trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
	trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")

# Merge test and train and give the names to the collums
	activity <- rbind(testActivity, trainActivity)
	names(activity) <- "Activity"
	subject <- rbind(testSubject, trainSubject)
	names(subject) <- "Subject"
	data <- rbind(testData, trainData)
	features <- read.table("./UCI HAR Dataset/features.txt")
	names(data) <- features$V2
	
# Combine activity, subject and features
	data_activity <- cbind(data, activity)
	totalData <- cbind(data_activity, subject)	
	
# Extract mean & std
	subNames<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
	selectedNames<-c(as.character(subNames), "Subject", "Activity")
	subData <- subset(totalData,select = selectedNames)
	
# Activity labels into dataset
	activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
	labelNames <- as.character(activityLabels$V2)
	subData$Activity[subData$Activity==1] <-labelNames[1]
	subData$Activity[subData$Activity==2] <-labelNames[2]
	subData$Activity[subData$Activity==3] <-labelNames[3]
	subData$Activity[subData$Activity==4] <-labelNames[4]
	subData$Activity[subData$Activity==5] <-labelNames[5]
	subData$Activity[subData$Activity==6] <-labelNames[6]
	
# descriptive variable names into dataset
		#prefix t = time
		#prefix f = frequency
		#Acc = Accelerometer
		#Gyro = Gyroscope
		#Mag = Magnitude	
	names(subData) <- sub("^t","time",names(subData))
	names(subData) <- sub("^f","frequency",names(subData))
	names(subData) <- sub("Acc","Accelerometer",names(subData))
	names(subData) <- sub("Gyro","Gyroscope",names(subData))
	names(subData) <- sub("Mag","Magnitude",names(subData))

# create a second dataset; average of each variable for each activity and each subject
	subData2 <- aggregate(. ~Subject + Activity, subData, mean)
 	subData2 <- subData2[order(subData2$Subject,Data2$Activity),]
 	write.table(subData2, file = "tidydata.txt",row.name=FALSE)