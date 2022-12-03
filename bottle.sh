#!/usr/bin/env bash

formulae=$1

# Install Git LFS
brew install git-lfs
git lfs install

# Tap HTT
brew tap celsiusnarhwal/htt

for formula in $formulae; do
  # Bottle formula
  brew install --build-bottle "$(basename "$formula" .rb)"
  brew bottle --json "$(basename "$formula" .rb)"

  # Merge DSL
  json_file=$(find . -name "*.json")
  brew bottle --merge --write "$json_file"
done

# Commit and push changes
cd "$(brew --prefix)"/Homebrew/Library/Taps/celsiusnarhwal/homebrew-htt || exit
mv ./*.tar.gz Bottles
git lfs track "*.tar.gz"
git add -A && git commit -m "Update bottles"
git pull --merge
git push