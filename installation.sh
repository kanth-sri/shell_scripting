#!/bin/bash

USER_ID=$(id -u)

if( $USER_ID -ne 0 )
then 
    echo "Please execute this script with root priviliges..."
    exit 1
fi

dnf list installed git