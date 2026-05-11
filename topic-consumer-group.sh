#!/bin/bash
. ./global_functions.sh

path="$1 \\ Topics & consumer groups"
topicName=""
consumerGroupName=""
finish=0

function runCommand {
  echo "Selected $1:"
  if [ $2 != 0 ] && [ "$topicName" == "" ]
  then
      echo "Empty topic name!"
  elif [ $2 != 0 ] && [ "$consumerGroupName" == "" ]
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
  echo "Topic name: $topicName"
  echo "Consumer group name: $consumerGroupName"
  echo
  echo "0 -- Exit"
  echo "1 -- Set topic name"
  echo "2 -- Set consumer group name"
  echo "3 -- Reset offset to beginning"
  echo "4 -- Console read"
  echo "5 -- Console read 2"
  echo
  read -p "Selection$: " command
  echo

  case $command in
  0)
  finish=1
  ;;
  1)
  echo "Selected 1:"
  echo "Topic names list:"
  echo
  ../bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --list
  echo
  read -p "Input topic name: " topicName
  ;;
  2)
  echo "Selected 2:"
  echo "Consumer group names list:"
  echo
  ../bin/kafka-consumer-groups.sh --bootstrap-server $(serverName):$(serverPort) --list
  echo
  read -p "Input consumer group name: " consumerGroupName
  ;;
  3)
  runCommand $command "1" "bin/kafka-consumer-groups.sh --bootstrap-server $(serverName):$(serverPort) --group $consumerGroupName --topic $topicName --execute --reset-offsets --to-earliest"
  ;;
  4)
  runCommand $command "1" "bin/kafka-console-consumer.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --group $consumerGroupName --from-beginning"
  ;;
  5)
  runCommand $command "1" "bin/kafka-console-consumer.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --group $consumerGroupName --command-property auto.offset.reset=earliest"
  ;;
  *)
  echo -e "Unknown selection: $command"
  echo
  readKey
  ;;
  esac
done

exit 0









