#!/bin/bash

USER_ID=$(id -u)
LOG_FOLDER=/var/log/expense
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

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

mysql --version &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo -e "Mysql server is not installed, $G installing now $N" | tee -a $LOG_FILE
    dnf install mysql-server -y  &>>$LOG_FILE
    VALIDATE $? "Installing mysql"
else 
    echo -e "MYSQL server is already installed, $Y SKIPPING $N" | tee -a $LOG_FILE
fi

systemctl enable mysqld  &>>$LOG_FILE
VALIDATE $? "Enablin mysql"

systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "Starting mysql"

mysql -h mysql.srikanthadepu.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "MySQL root password is not setup, setting now" | tee -a $LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
fi


