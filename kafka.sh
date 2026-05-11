#!/bin/bash
. ./global_functions.sh

path="$1 \\ Kafka service"
finish=0

function runCommand {
  echo "Selected $1:"
  echo "$2"
  echo
  ../$2
  echo
  readKey
  return 0
}

while [ $finish = 0 ]
do
  clear
  echo $path
  echo
  echo "0 -- Exit"
  echo "1 -- Start kafka server"
  echo "2 -- Kafka version"
  echo
  echo -n "Selection:$ "

  read command
  echo

  case $command in
  0)
  finish=1
  ;;
  1)
  runCommand "1" "bin/kafka-server-start.sh ../config/server.properties"
  ;;
  2)
  runCommand "2" "bin/kafka-topics.sh --version"
  ;;
  *)
  echo -e "Unknown selection: $command"
  echo
  readKey
  ;;
  esac
done

exit 0












