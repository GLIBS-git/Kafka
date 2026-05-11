#!/bin/bash
. ./global_functions.sh

finish=0
path="Glibs: Kafka commands menu"

while [ $finish = 0 ]
do
  clear
  echo $path
  echo
  echo "0 -- Exit"
  echo "1 -- Kafka"
  echo "2 -- Topic"
  echo "3 -- Consumer group"
  echo "4 -- Topic & Consumer group"
  echo
  read -p "Selection$: " command
  echo

  case $command in
  0)
  echo "Exiting: $path"
  finish=1
  ;;
  1)
  ./kafka.sh "$path"
  ;;
  2)
  ./topic.sh "$path"
  ;;
  3)
  ./consumer-group.sh "$path"
  ;;
  4)
  ./topic-consumer-group.sh "$path"
  ;;
  *)
  echo "Unknown selection: $command"
  readKey
  ;;
  esac
done

exit 0
