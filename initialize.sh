#! /usr/bin/env bash

wd="$1"
srcdir="$( dirname "${BASH_SOURCE[0]}" )"

if [[ "$wd" == "" ]]; then
    # wd="$(pwd)"
    wd="."
fi

if [[ ! -d "$wd" ]]; then
    echo "${wd} not a directory"
    exit 1
fi

if [[ "$wd" == "." ]]; then
    echo -n "Initialize current directory? [y/n] "
else
    echo -n "Initialize ${wd}? [y/n] "
fi

read resp

if ! [[ "$resp" =~ [Yy].* ]]; then
    exit
fi

echo "Initializing..."


#~~~~~~~~
echo "Adding spamon"
touch "${wd}/spamon"

#~~~~~~~~
echo "Writing exclude files to .vscode/settings.json"
VSCSET="${wd}/.vscode/settings.json"

[[ -d "${wd}/.vscode" ]] || mkdir "${wd}/.vscode"
if [[ ! -f "$VSCSET" ]] || [[ $(stat -c %s "$VSCSET") == '0' ]]; then
    cp "${srcdir}/default.json" "$VSCSET"
else
    jq -s --indent 4 '.[0] * .[1]' "${srcdir}/default.json" "$VSCSET" > "$VSCSET.tmp"
    mv -f "$VSCSET.tmp" "$VSCSET"
    rm -f "$VSCSET.tmp"
fi


#~~~~~~~~
echo "Applying clang-format to .h .cc"
# syntax will not work on macos
find "${wd}" -type f -regextype posix-extended -regex ".+\.(h|cc)" -exec \
    clang-format -i {} \;



#~~~~~~~~
echo "Adding color messages to Makefile"
MKFILE="${wd}/Makefile"
grep "PASS =" MKFILE > /dev/null
if [[ $? -ne 0 ]]; then
    sed -i '1s/^/FAIL := $(shell echo "\\e[0;31mfail\\e[0m")\n/' MKFILE
    sed -i '1s/^/PASS := $(shell echo "\\e[0;32mpass\\e[0m")\n/' MKFILE
    sed -i 's/"pass"/"$(PASS)"/' MKFILE
    sed -i 's/"fail"/"$(FAIL)"/' MKFILE
fi

#~~~~~~~~
echo ""
echo "Review changes before committing."

# set up mirror remote one github
#   git remote add --mirror=push github <github url>

#   probably better to push to mirror when updating lab machine
#   so that a test commit doesn't have to run on gheith's server


#  remember to not push branches to gheith's server
