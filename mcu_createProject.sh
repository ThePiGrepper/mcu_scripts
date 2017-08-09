#!/bin/bash

#mcu_createProject creates a new folder named 'projectName'
#with the MCU project structure inside.
#usage: ./mcu_createProject <projectName> <mcu_type>
if test $# -ne 2 ; then
  echo -e "Usage: mcu_createProject <projectName> <mcu_type>\n\
Incorrect Parameter count($#).abort"
  exit 1
fi
projectName=$1
mcu_type=$2

if test -e $projectName; then
  echo 'File/Folder already exists. abort'
  exit 1
fi
#check if $BSYNC_PATH exists and it's a valid folder
if test -z $BSYNC_PATH ; then
  echo "BSYNC_PATH is not set. abort"
  exit 1
fi
if test ! -d $BSYNC_PATH ; then
  echo "BSYNC_PATH not a valid directory.abort"
  exit 1
fi
#validate mcu_type. Check if it's a valid tag
git -C ${BSYNC_PATH}/simple_test tag | grep $mcu_type >/dev/null 2>&1
if test $? -eq 1 ; then
  echo "$mcu_type is not a valid tag. abort"
  exit 1
fi
mkdir $projectName
if test $? -eq 1; then
  echo "$projectName folder couldn't be created. abort"
  exit 1
fi
git -C $BSYNC_PATH/simple_test archive $mcu_type | tar Cx $projectName
echo "Project Folder '$projectName' created successfully for $mcu_type"
