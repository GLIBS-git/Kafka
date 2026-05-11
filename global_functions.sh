#!/bin/bash

function readKey {
read -rsp $'Press any key to continue...\n' -n 1
return 0
}

function serverName {
echo "localhost"
return 0
}

function serverPort {
echo "9092"
return 0
}

