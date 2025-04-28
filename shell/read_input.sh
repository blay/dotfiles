#!/bin/bash

  while [[ 1 ]]
  do
    read -sn1 INPUT
    echo $INPUT
    if [ "$INPUT" == "a" ]; then
      echo "hooray"
      ls
    else
      echo "ney"
    fi
  done
  }