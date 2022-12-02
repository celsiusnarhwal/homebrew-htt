#!/usr/bin/env bash

formula=$1

brew install libgit2
brew install --build-bottle celsiusnarhwal/htt/"$formula"
brew bottle --json "$formula" --root-url=https://github.com/celsiusnarhwal/homebrew-htt/blob/HEAD/Bottles

json_file=$(find . -name "*.json")
python bottler.py "$json_file"

bottle_file=$(find . -name "*.tar.gz")
echo "Uploading $bottle_file"

brew bottle --merge --write "$json_file" --no-commit