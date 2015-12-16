#!/bin/bash

if test -d $1
then
  #echo ----- $1 -----

  TEST_RESULT=""
  tot=0
  for PROBLEM in 1 2 3 4 5
  do
    #echo "문제 ${PROBLEM}번"

    bash ./compile.sh $1/$PROBLEM/$PROBLEM

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
        timeout=60
      fi
      INPUT=$(cat ./test_case/$PROBLEM/${TEST_CASE}.in)
      OUTPUT=$(gtimeout $timeout sh ./run.sh $1/$PROBLEM/$PROBLEM INPUT)
      DESIRED=$(cat ./test_case/$PROBLEM/${TEST_CASE}.out)

      OUTPUT=$(echo $OUTPUT | sed -e 's/[[:space:]]+\n/\n/g')
      
      if [ "$OUTPUT" == "$DESIRED" ]
      then
        RESULT="O"
        cnt=$(($cnt + 1))
      else
        RESULT="X"
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
