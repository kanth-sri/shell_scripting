#!/bin/bash

USER_ID=$(id -u)
#color codes in linux shell scripting
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){
    if [ $USER_ID -nq 0 ]
    then
        echo -e " $R Please execute this script with root priviliges... $N"
    fi
}

CHECK_ROOT