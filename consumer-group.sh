#!/bin/bash
. ./global_functions.sh

path="$1 \\ Consumer groups"
consumerGroupName=""
finish=0

function runCommand {
  echo "Selected $1:"
  if [ $2 != 0 ] && [ "$consumerGroupName" == "" ]
  then
      echo "Empty consumer group name!"
  else
      echo "$3"
      echo
      ../$3
  fi
  echo
  readKey
  return 0
}

while [ $finish = 0 ]
do
  clear
  echo $path
  echo
  echo "Consumer group name: $consumerGroupName"
  echo
  echo "0 -- Exit"
  echo "1 -- List"
  echo "2 -- Set name"
  echo "3 -- Group description"
  echo "4 -- Delete"
  echo
  read -p "Selection$: " command
  echo

  case $command in
  0)
  finish=1
  ;;
  1)
  runCommand $command 0 "bin/kafka-consumer-groups.sh --bootstrap-server $(serverName):$(serverPort) --list"
  ;;
  2)
  echo "Selected $command:"
  echo "Consumer group list:"
  echo
  ../bin/kafka-consumer-groups.sh --bootstrap-server $(serverName):$(serverPort) --list
  echo
  read -p "Input consumer group name: " consumerGroupName
  ;;
  3)
  runCommand $command 1 "bin/kafka-consumer-groups.sh --bootstrap-server $(serverName):$(serverPort) --group $consumerGroupName --describe"
  ;;
  4)
  runCommand $command 1 "bin/kafka-consumer-groups.sh --bootstrap-server $(serverName):$(serverPort) --group $consumerGroupName --delete"
  ;;
  *)
  echo -e "Unknown selection: $command"
  echo
  readKey
  ;;
  esac
done

exit 0









