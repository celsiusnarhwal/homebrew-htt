import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

os.chdir(subprocess.run(["brew", "--repo", "celsiusnarhwal/htt"], capture_output=True).stdout.decode().strip())

formula, platform = Path(sys.argv[1]).stem, sys.argv[2]
formula_info = json.loads(subprocess.run(["brew", "info", "--json=v2", formula], capture_output=True).stdout.decode())
formulae_version = formula_info["formulae"][0]["versions"]["stable"]
release_tag = f"{formula}-{formulae_version}"
release_title = f"{formula} {formulae_version}"
root_url = f"https://github.com/celsiusnarhwal/homebrew-htt/releases/download/{release_tag}"

subprocess.run(["brew", "install", "--build-bottle", f"celsiusnarhwal/htt/{formula}"])

bottle = subprocess.run(
    ["brew", "bottle", "--json", formula, f"--root_url={root_url}"],
    capture_output=True
).stdout.decode()

bottle = Path(re.search(r"\./.*\.tar\.gz", bottle).group(0)).resolve()

assets = [bottle]

# GitHub's macOS runners currently only support Intel architecture so we need to duplicate and rename macOS
# bottles for Apple silicon.
if "macos" in platform:
    osx = {"macos-11": "big_sur", "macos-12": "monterey"}[platform]
    assets.append(Path(shutil.copy(bottle, bottle.name.replace(osx, f"arm64_{osx}"))).resolve())

    json_file = next(Path.cwd().glob(f"{formula}*.json"))

    bottle_json = json.load(json_file.open())

    bottle_json[next(iter(bottle_json))]["bottle"]["tags"][f"arm64_{osx}"] = \
        bottle_json[next(iter(bottle_json))]["bottle"]["tags"][osx]

    json.dump(bottle_json, json_file)

try:
    subprocess.run(
        ["gh", "release", "create", release_tag, "--title", release_title, "--notes", f"{release_title} bottles"],
        check=True
    )
except subprocess.CalledProcessError:
    pass

subprocess.run(["gh", "release", "upload", release_tag, *assets, "--clobber"])
