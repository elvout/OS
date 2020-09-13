#! /usr/bin/env bash

declare -i runs=200

for i in $(seq 1 $runs); do
    make -s $1.test > /dev/null

    if [[ $? != 0 ]]; then
        echo "make failed to build"
        break
    fi

    grep "fail" $1.result &> /dev/null

    if [[ $? == 0 ]]; then
        echo ""
        echo "test failed"
        break
    fi

    printf "\e[2K\e[1G$i/$runs\e[1G"
done
