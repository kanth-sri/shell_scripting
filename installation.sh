#!/bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]  
then 
    echo "Please execute this script with root priviliges..."
    exit 1
fi

dnf list installed git

if [ $? -eq 0 ]
then
    echo "Git is already installed....nothing todo"
else
    echo "Git is not installed.., installing now"
    dnf install git -y
    
fi
