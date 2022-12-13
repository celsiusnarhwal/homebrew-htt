# Build and publish bottles.

import json
import os
import re
import subprocess
import sys

from github import Github as GitHub
from path import Path


class AssetList(list):
    def append(self, asset_path: Path) -> None:
        asset_path = asset_path.realpath()

        if not isinstance(asset_path, Path):
            raise TypeError("asset_path must be a Path object")

        if not asset_path.exists():
            raise FileNotFoundError(asset_path)

        if not asset_path.isfile():
            raise IsADirectoryError(asset_path)

        super().append(asset_path)


assets = AssetList()

gh = GitHub(os.getenv("GITHUB_TOKEN"))
htt = gh.get_repo("celsiusnarhwal/homebrew-htt")

formula, platform = Path(sys.argv[1]).stem, sys.argv[2]
formula_info = json.loads(subprocess.run(["brew", "info", "--json=v2", formula], capture_output=True).stdout.decode())
formula_version = formula_info["formulae"][0]["versions"]["stable"]
release_tag = f"{formula}-{formula_version}"

subprocess.run(["brew", "install", "--build-bottle", f"celsiusnarhwal/htt/{formula}"])

bottle = subprocess.run(
    ["brew", "bottle", "--json", formula, f"--root_url={htt.html_url}/releases/download/{release_tag}"],
    capture_output=True
).stdout.decode()

bottle = Path.getcwd() / re.search(r"\./.*\.tar\.gz", bottle).group(0)
bottle = bottle.rename(bottle.name.replace("--", "-"))
assets.append(bottle)

if "macos" in platform:
    # GitHub's macOS runners currently only support Intel architecture so we need to duplicate and rename macOS
    # bottles for Apple silicon.
    osx = {"macos-11": "big_sur", "macos-12": "monterey"}[platform]
    assets.append(Path(bottle.copy(bottle.name.replace(osx, f"arm64_{osx}"))))

    json_file = next(Path.getcwd().walkfiles(f"{formula}*.json"))

    bottle_json = json.load(json_file.open())

    bottle_json[next(iter(bottle_json))]["bottle"]["tags"][f"arm64_{osx}"] = \
        bottle_json[next(iter(bottle_json))]["bottle"]["tags"][osx]

    json.dump(bottle_json, json_file.open("w"))

source = gh.get_repo(f"celsiusnarhwal/{formula}")
release_title = f"{source.name} {formula_version}"
release_notes_url = next(r for r in source.get_releases() if r.tag_name == formula_version).html_url
license_url = source.get_license().html_url

release_body = f"""
```bash
brew install celsiusnarhwal/htt/{formula}
```

[Source Repository]({source.html_url}) | [Release Notes]({release_notes_url}) | [License]({license_url})
"""

with Path(subprocess.run(["brew", "--repo", "celsiusnarhwal/htt"], capture_output=True).stdout.decode().strip()):
    try:
        subprocess.run(
            ["gh", "release", "create", release_tag, "--title", release_title, "--notes", release_body],
            check=True
        )
    except subprocess.CalledProcessError:
        pass

    if not all(asset.exists() for asset in assets):
        nonexistent = [asset for asset in assets if not asset.exists()]
        raise FileNotFoundError(f"Could not find the following files: {chr(10).join(nonexistent)}")

    for asset in assets:
        subprocess.run(
            ["gh", "release", "upload", release_tag, asset, "--clobber"],
            check=True
        )
