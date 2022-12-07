#!/usr/bin/env bash

formula=$1
formula_name="$(basename "$formula" .rb)"
root_url="https://ghcr.io/v2/celsiusnarhwal/htt"

# Tap HTT
brew tap celsiusnarhwal/htt

# Bottle formula
brew install --build-bottle "$(basename "$formula" .rb)"
brew bottle --json "$(basename "$formula" .rb)"

# Merge DSL
json_file=$(find . -name "*.json")
brew bottle --merge --write "$json_file" --root-url="$root_url"

bottle=$(find . -name "$formula_name*.tar.gz")
version=$(echo "$bottle" | sed -E "s/.*$formula_name-([0-9.]+)\.tar\.gz/\1/")
sha256=$(docker import "$bottle" | sed -E "s/.*sha256:(.*)/\1/")
docker tag "$sha256" "$root_url/$formula_name:$version@sha256:$sha256"
docker push "$sha256"

# Commit and push changes
cd "$(brew --prefix)"/Homebrew/Library/Taps/celsiusnarhwal/homebrew-htt || exit
git pull --merge
git push