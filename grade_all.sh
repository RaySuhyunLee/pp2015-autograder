#!/bin/bash

RESULT_ALL="학번"

for i in 1 2 3 4 5
do
  for j in 1 2 3 4
  do
    RESULT_ALL="$RESULT_ALL,\"${i}-${j}\""
  done

  RESULT_ALL="$RESULT_ALL,합계"
done

RESULT_ALL="$RESULT_ALL,총점"
(printf $RESULT_ALL) > final_result.csv

for STUDENT in ./students/*
do
  echo ---------- $STUDENT ----------
  RESULT=$(bash ./grade_one.sh $STUDENT)
  RESULT_ALL="$(cat final_result.csv)\n${RESULT}"
  (printf $RESULT_ALL) > final_result.csv
done
