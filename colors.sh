#!/bin/bash

USER_ID=$(id -u)
package="mysql"
#color codes in linux shell scripting
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
        echo "$package  installation....$G SUCCESS $N"
    else
        echo "$package installation...$R FAILED $N"
    fi
}
CHECK_ROOT

dnf list installed $package

if [ $? -eq 0 ]
then
    echo "$package $G is already installed $N ....nothing todo"
else
    echo "$package $R is not installed $N.., installing now"
    dnf install $package -y
    VALIDATE $?
fi
