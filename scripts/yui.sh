# Bottle a formula given its name and a target platform.

cd "$(brew --repo celsiusnarhwal/htt)"

# Extract the formula name, formula version, and target platform from the input.
formula=$(basename "$1" .rb)
formula_version=$(brew info --json=v2 "$formula" | jq -r '.formulae[0].versions.stable')
platform=$2

# Build the bottle.
brew install --build-bottle celsiusnarhwal/htt/"$formula"
bottle_file=$(brew bottle --json "$formula" --root-url="https://github.com/celsiusnarhwal/homebrew-htt/releases/download/$formula-$formula_version" | grep -o "\./.*\.tar\.gz")

# Determine the files to be uploaded to GitHub.
assets=$(python3 scripts/mio.py "$bottle_file" "$platform")

# Upload the bottle files to GitHub.
gh release create "$formula-$formula_version" --title "$formula $formula_version" --notes "$formula $formula_version bottles" || true
for asset in $assets; do
  gh release upload "$formula-$formula_version" "$asset" --clobber
done
