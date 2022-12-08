#!/usr/bin/env bash

formula=$1

# Tap HTT
brew tap celsiusnarhwal/htt

# Bottle formula
brew install --build-bottle "$(basename "$formula" .rb)"
brew bottle --json "$(basename "$formula" .rb)"

# Upload bottle
brew pr-upload --root-url="https://ghcr.io/v2/celsiusnarhwal/htt"

# Push formula changes
cd "$(brew --prefix)"/Homebrew/Library/Taps/celsiusnarhwal/homebrew-htt || exit
git pull --merge
git push