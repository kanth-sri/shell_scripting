#!/bin/bash

USER_ID=$(id -u)
LOG_FOLDER=/var/log/expense
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
NODE_VER=$(node -v | cut -d "." -f1) 

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){
    if [ $USER_ID -ne 0 ]
    then
        echo -e " $R Please execute this script with root priviliges... $N" 
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is....$G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is....$R FAILED $N" | tee -a $LOG_FILE
    fi
}
CHECK_ROOT
mkdir -p $LOG_FOLDER
echo "Script execution started at: $(date)" | tee -a $LOG_FILE

if [ $NODE_VER == "v20" ]
then 
    echo -e "Nodejs:v20 is already installed... $Y SKIPPING $N"
else
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling nodejs:20"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing nodejs"
fi

id expense &>>$LOG_FILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOG_FILE
    VALIDATE $? "creating expense user"
else 
    echo -e "expense user  already exists... $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOG_FILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading backend code"

cd /app
unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Unzip backend code into app dir"

cd /app
npm install &>>$LOG_FILE
VALIDATE $? "Installing dependencies"

cp /home/ec2-user/shell_scripting/expense/backend.service /etc/systemd/system/backend.service
VALIDATE $? "copy of backend service file"
