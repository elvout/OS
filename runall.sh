#! /usr/bin/env zsh

if [[ $TESTS_DIR == "" ]]; then
    TESTS_DIR="."
fi

for test in $TESTS_DIR/*.ok; do
    name=${test:t:r}

    printf "\e[2K\e[1G"
    echo $name
    ../breakonfail.sh $name
    echo "\e[2K\e[1G---"
done
