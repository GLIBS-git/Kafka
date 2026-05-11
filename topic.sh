#!/bin/bash
. ./global_functions.sh

path="$1 \\ Topics"
topicName=""
finish=0

function runCommand {
  echo "Selected $1:"
  if [ $2 != 0 ] && [ "$topicName" == "" ]
  then
      echo "Empty topic name!"
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
  echo
  echo "0 -- Exit"
  echo "1 -- List"
  echo "2 -- Set name"
  echo "3 -- Create"
  echo "4 -- Delete"
  echo "5 -- Topic description"
  echo "6 -- Add partitions"
  echo "7 -- Console write to topic"
  echo "8 -- Console read from topic"
  echo "9 -- Console read from topic 2"
  echo "10 -- Set log retention (period after which messages are cleaned)"
  echo "11 -- Set segment rotation (period after which new flile on disk for topic created)"
  echo "12 -- Set log retention policy"
  echo
  read -p "Selection$: " command
  echo

  case $command in
  0)
  finish=1
  ;;
  1)
  runCommand $command 0 "bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --list"
  ;;
  2)
  echo "Selected $command:"
  echo "Topic names list:"
  echo
  ../bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --list
  echo
  read -p "Input topic name: " topicName
  ;;
  3)
  runCommand $command 1 "bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --create"
  ;;
  4)
  runCommand $command 1 "bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --delete"
  ;;
  5)
  runCommand $command 1 "bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --describe"
  ;;
  6)
  read -p "Input number of partitions: " partitionsNum
  if [[ $partitionsNum =~ ^[0-9]+$ ]] && (( partitionsNum > 0 ))
  then
      runCommand $command 1 "bin/kafka-topics.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --alter --partitions $partitionsNum"
  else
      echo "$partitionsNum is not a positive integer number"
      readKey
  fi
  ;;
  7)
  runCommand $command 1 "bin/kafka-console-producer.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName"
  ;;
  8)
  runCommand $command 1 "bin/kafka-console-consumer.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --from-beginning"
  ;;
  9)
  runCommand $command 1 "bin/kafka-console-consumer.sh --bootstrap-server $(serverName):$(serverPort) --topic $topicName --command-property auto.offset.reset=earliest"
  ;;
  10)
  read -p "Input retention in minutes: " logRetention
  logRetention=$((logRetention))
  if [[ $logRetention =~ ^[0-9]+$ ]] && (( logRetention > 0 ))
  then
      logRetention=$((logRetention*60*1000))
      runCommand $command 1 "bin/kafka-configs.sh --bootstrap-server $(serverName):$(serverPort) --entity-type topics --entity-name $topicName --alter --add-config retention.ms=$logRetention"
  else
      echo "$logRetention is not a positive integer number"
      readKey
  fi
  ;;
  11)
  read -p "Input segment rotation in minutes: " segmentMs
  segmentMs=$((segmentMs))
  if [[ $segmentMs =~ ^[0-9]+$ ]] && (( segmentMs > 0 ))
  then
      segmentMs=$((segmentMs*60*1000))
      runCommand $command 1 "bin/kafka-configs.sh --bootstrap-server $(serverName):$(serverPort) --entity-type topics --entity-name $topicName --alter --add-config segment.ms=$segmentMs"
  else
      echo "$segmentMs is not a positive integer number"
      readKey
  fi
  ;;
  12)
  echo "Select log retention policy:"
  echo "1 - Delete"
  echo "2 - Compact"
  echo "3 - Delete + Compact"
  read -p "Input selection: " policy
  case $policy in
  1)
    runCommand $command 1 "bin/kafka-configs.sh --bootstrap-server $(serverName):$(serverPort) --entity-type topics --entity-name $topicName --alter --add-config cleanup.policy=delete"
  ;;
  2)
    runCommand $command 1 "bin/kafka-configs.sh --bootstrap-server $(serverName):$(serverPort) --entity-type topics --entity-name $topicName --alter --add-config cleanup.policy=compact"
  ;;
  3)
    runCommand $command 1 "bin/kafka-configs.sh --bootstrap-server $(serverName):$(serverPort) --entity-type topics --entity-name $topicName --alter --add-config cleanup.policy=[compact,delete]"
  ;;
  *)
  echo -e "Incorrect policy selection: $policy"
  echo
  readKey
  ;;
  esac
  ;;
  *)
  echo -e "Unknown selection: $command"
  echo
  readKey
  ;;
  esac
done

exit 0









