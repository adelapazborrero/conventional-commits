#!/bin/bash

COMMIT_MESSAGE=$1
COMMIT_TITLE=$2
COMMIT_TYPES=("build" "chore" "ci" "docs" "feat" "fix" "perf" "refactor" "revert" "style" "test")

SET_COMMIT_TYPE=$(echo $COMMIT_MESSAGE | sed 's/:.*//')
COMMIT_SCOPE=$(echo "$SET_COMMIT_TYPE" | sed -n 's/.*\(([^()]*)\).*/\1/p')
SIZE=${#COMMIT_TITLE}

CLEAN_TYPE=$(echo ${SET_COMMIT_TYPE%"("*})
CLEAN_TYPE=$(echo ${CLEAN_TYPE%"!"*})

if [[ -z $COMMIT_MESSAGE ]]; then
  echo "No commit message"

# echo in case commit message is correct 
elif [[ " ${COMMIT_TYPES[*]} " =~ " ${CLEAN_TYPE} " ]]; then
  if [[ $SIZE -gt 72 ]]; then
    echo "❌ Commit message should have lines of less than 72 characters, current length is $SIZE"
    exit 1
  fi

  echo ""
  echo "✅ Commit type \"$CLEAN_TYPE\" follows the conventional commit guidelines"


  # echo breaking change in case of breaking change
  if [[ "$SET_COMMIT_TYPE" == *"!"* ]]; then
    echo "🚩 BREAKING CHANGE"
  fi

  # echo scope of commit in case of scope
  if [[ ! -z $COMMIT_SCOPE ]]; then
    echo "   Scope: $COMMIT_SCOPE"
  fi

  if [[  " $COMMIT_MESSAGE " != *"Refs: "* ]]; then
    echo -e "\e[3m☉ Commit message does not contain a reference\e[0m"
  fi

#echo in case commit message does not follow conventional commit guidelines
else
  echo "❌ Commit type is \"$SET_COMMIT_TYPE\", please use one of the following:"
  echo "   ${COMMIT_TYPES[*]}"
  exit 1
fi
