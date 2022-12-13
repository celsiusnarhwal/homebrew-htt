import json
import os
import re
import subprocess
import sys

from github import Github as GitHub
from path import Path

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

bottle = Path(re.search(r"\./.*\.tar\.gz", bottle).group(0)).realpath()

assets = [bottle]

if "macos" in platform:
    # GitHub's macOS runners currently only support Intel architecture so we need to duplicate and rename macOS
    # bottles for Apple silicon.
    osx = {"macos-11": "big_sur", "macos-12": "monterey"}[platform]
    assets.append(bottle.copy(bottle.name.replace(osx, f"arm64_{osx}")))

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

    subprocess.run(["gh", "release", "upload", release_tag, *assets, "--clobber"])
