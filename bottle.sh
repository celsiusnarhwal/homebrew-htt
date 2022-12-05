#!/usr/bin/env bash

formulae=$1
root_url="https://ghcr.io/v2/celsiusnarhwal/htt"

# Tap HTT
brew tap celsiusnarhwal/htt

for formula in $formulae; do
  formula_name="$(basename "$formula" .rb)"
  # Bottle formula
  brew install --build-bottle "$(basename "$formula" .rb)"
  brew bottle --json "$(basename "$formula" .rb)"

  # Merge DSL
  json_file=$(find . -name "*.json")
  brew bottle --merge --write "$json_file" --root-url="$root_url"

  bottle=$(find . -name "$formula_name*.tar.gz")
  version=$(echo "$bottle" | sed -E "s/.*$formula_name-([0-9.]+)\.tar\.gz/\1/")
  systemctl start docker
  echo "$GITHUB_TOKEN" | docker login ghcr.io -u celsiusnarhwal --password-stdin
  sha256=$(docker import "$bottle" | sed -E "s/.*sha256:(.*)/\1/")
  docker tag "$sha256" "$root_url/$formula_name:$version@sha256:$sha256"
  docker push "$root_url/$formula_name:$version@sha256:$sha256"
done
#
#bottles=$(find . -name "*.tar.gz")
#for bottle in $bottles; do
#  name="$(grep "")"
#  sha256=$(docker import "$bottle")
#  docker tag "$sha256" ghcr.io/celsiusnarhwal/homebrew-htt:"$(basename "$bottle" .tar.gz)"
#  docker push ghcr.io/celsiusnarhwal/homebrew-htt:"$(basename "$bottle" .tar.gz)"
#done


# Commit and push changes
cd "$(brew --prefix)"/Homebrew/Library/Taps/celsiusnarhwal/homebrew-htt || exit
git pull --merge
git push