#!/usr/bin/env bash

formulae=$1


# Tap HTT
brew tap celsiusnarhwal/htt

# Install Docker
brew install docker

# Authenticate with GHCR
echo "$GITHUB_TOKEN" | docker login ghcr.io -u celsiusnarhwal --password-stdin

for formula in $formulae; do
  # Bottle formula
  brew install --build-bottle "$(basename "$formula" .rb)"
  brew bottle --json "$(basename "$formula" .rb)"

  # Merge DSL
  json_file=$(find . -name "*.json")
  brew bottle --merge --write "$json_file" --root-url="https://ghcr.io/v2/celsiusnarhwal/homebrew-htt"
done

bottles=$(find . -name "*.tar.gz")
for bottle in $bottles; do
  sha256=$(docker import "$bottle")
  docker tag "$sha256" ghcr.io/celsiusnarhwal/homebrew-htt:"$(basename "$bottle" .tar.gz)"
  docker push ghcr.io/celsiusnarhwal/homebrew-htt:"$(basename "$bottle" .tar.gz)"
done


# Commit and push changes
cd "$(brew --prefix)"/Homebrew/Library/Taps/celsiusnarhwal/homebrew-htt || exit
git add -A && git commit -m "Update bottles"
git pull --merge
git push