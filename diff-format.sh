#! /usr/bin/env bash

file=$1

diff --color "$file" <(clang-format "$file")
