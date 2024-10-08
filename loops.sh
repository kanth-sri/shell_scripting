#!/bin/bash

USER_ID=$(id -u)

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
        echo -e "$package  installation....$G SUCCESS $N"
    else
        echo -e "$package installation...$R FAILED $N"
    fi
}
USAGE(){
    echo -e "$Y USAGE: $0 package1 package2 .. $N"
    exit 1
}
CHECK_ROOT
if [ $# -eq 0 ]
then
    USAGE
fi

for package in $@
do
    dnf list installed $package
    if [ $? -eq 0 ]
    then
        echo -e "$package $G is already installed $N ....nothing todo"
    else
        echo -e "$package $R is not installed $N.., installing now"
        dnf install $package -y
        VALIDATE $?
    fi

done
