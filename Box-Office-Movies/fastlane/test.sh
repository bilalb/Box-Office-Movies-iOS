#!/bin/bash

language=${language:-en}
appearance=${appearance:-light}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi

  shift
done

echo $language $appearance


# ./test.sh --language language --appearance appearance
