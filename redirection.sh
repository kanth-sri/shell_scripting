#!/bin/bash

USER_ID=$(id -u)
LOG_FOLDER=/var/log/script-logs
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$SCRIPT_NAME-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){
    if [ $USER_ID -ne 0 ]
    then
        echo -e " $R Please execute this script with root priviliges... $N" | tee -a $LOG_FOLDER/$LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$package  installation....$G SUCCESS $N" | tee -a $LOG_FOLDER/$LOG_FILE
    else
        echo -e "$package installation...$R FAILED $N" | tee -a $LOG_FOLDER/$LOG_FILE
    fi
}
USAGE(){
    echo -e "$Y USAGE: $0 package1 package2 .. $N"
    exit 1
}
CHECK_ROOT
mkdir -p $LOG_FOLDER

if [ $# -eq 0 ]
then
    USAGE
fi

for package in $@
do
    dnf list installed $package &>>$LOG_FOLDER/$LOG_FILE
    if [ $? -eq 0 ]
    then
        echo -e "$package $G is already installed $N ....nothing todo" | tee -a $LOG_FOLDER/$LOG_FILE
    else
        echo -e "$package $R is not installed $N.., installing now" | tee -a $LOG_FOLDER/$LOG_FILE
        dnf install $package -y &>>$LOG_FOLDER/$LOG_FILE
        VALIDATE $?
    fi

done
