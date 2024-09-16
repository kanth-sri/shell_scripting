#!/bin/bash

USER_ID=$(id -u)
package=mysql

VALIDATE(){
    if [ $? -eq 0 ]
    then
        echo "$package  installation....SUCCESS"
    else
        echo "$package installation...FAILED"
    fi
}

if [ $USER_ID -ne 0 ]  
then 
    echo "Please execute this script with root priviliges..."
    exit 1
fi

dnf list installed $package

if [ $? -eq 0 ]
then
    echo "$package is already installed....nothing todo"
else
    echo "$package is not installed.., installing now"
    dnf install $package -y
    VALIDATE
fi
