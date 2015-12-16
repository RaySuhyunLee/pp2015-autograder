#!/bin/bash

if test -d $1
then
  #echo ----- $1 -----

  TEST_RESULT=""
  tot=0
  for PROBLEM in 1 2 3 4 5
  do
    #echo "문제 ${PROBLEM}번"

    path_to_problem=""
    if test -e $1/$PROBLEM/${PROBLEM}.c; then
      path_to_problem=$1/$PROBLEM/$PROBLEM
    elif test -e $1/${PROBLEM}.c; then
      path_to_problem=$1/$PROBLEM
    fi
    bash ./compile.sh $path_to_problem 

    cnt=0
    for TEST_CASE in 1 2 3 4 
    do
      if [ $PROBLEM = 2 ]; then
        case $TEST_CASE in
          1) timeout=1 ;;
          2) timeout=10 ;;
          3) timeout=45 ;;
          4) timeout=60 ;;
        esac
      else
        timeout=5
      fi

      # start running
      #echo begin
      if [ $PROBLEM = 3 ]; then
        sub_cnt=0
        for SUB in 1 2; do
          INPUT="./test_case/$PROBLEM/${TEST_CASE}-${SUB}.in"
          TEXT="./test_case/$PROBLEM/${TEST_CASE}.txt"
          OUTPUT=$(gtimeout $timeout bash ./run_3.sh $path_to_problem $TEXT $INPUT)
          DESIRED=$(cat ./test_case/$PROBLEM/${TEST_CASE}-${SUB}.out)

          if [ "$(echo $OUTPUT)" == "$(echo $DESIRED)" ]; then
            sub_cnt=$(($sub_cnt + 1))
          fi
        done

        if [ $sub_cnt = 2 ]; then
          RESULT="O"
          cnt=$(($cnt + 1))
        else
          RESULT="X"
        fi
      else # problem 1, 2, 4, 5
        INPUT="./test_case/$PROBLEM/${TEST_CASE}.in"
        OUTPUT=$(gtimeout $timeout sh ./run.sh $path_to_problem $INPUT)
        DESIRED=$(cat ./test_case/$PROBLEM/${TEST_CASE}.out)
        #echo finished  

        #echo $OUTPUT
        OUTPUT=$(echo $OUTPUT | sed -e 's/[[:space:]]+\n/\n/g')

        if [ "$(echo $OUTPUT)" == "$(echo $DESIRED)" ]; then
          RESULT="O"
          cnt=$(($cnt + 1))
        else
          RESULT="X"
        fi
      fi
      TEST_RESULT="$TEST_RESULT\"$RESULT\","
    done

    TEST_RESULT="${TEST_RESULT}${cnt},"
    tot=$(($tot + $cnt))
  done
  
  STUDENT_NUMBER=$(echo $1 | sed "s/.\/students\///g")
  echo "$STUDENT_NUMBER,$TEST_RESULT$tot"
else
  echo "Directory named $1 doesn't exist"
fi
