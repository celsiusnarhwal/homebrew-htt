#!/usr/bin/env bash

formula=$1

mkdir -p bottle && cd bottle || exit
brew bottle --json "$formula" --root-url=https://github.com/celsiusnarhwal/"$formula"/blob/HEAD/Bottles

json_file=$(find . -name "*.json")
python ../bottler.py "$json_file"

brew bottle --merge --write "$json_file" --no-commit