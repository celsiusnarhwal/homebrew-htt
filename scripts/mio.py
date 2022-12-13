import json
import re
import shutil
import sys
from pathlib import Path

htt = Path(__file__).parent.parent

bottle, platform = Path(sys.argv[1]).rename(sys.argv[1].replace("--", "-")).resolve(), sys.argv[2]

assets = [bottle]

# GitHub's macOS runners currently only support Intel architecture so we need to duplicate and rename macOS
# bottles for Apple silicon.
if "macos" in platform:
    osx = {"macos-11": "big_sur", "macos-12": "monterey"}[platform]
    assets.append(Path(shutil.copy(bottle, bottle.name.replace(osx, f"arm64_{osx}"))).resolve())
    json_filename = re.sub(r"(\.\d*\.tar\.gz)", ".json", bottle.name.replace("-", "--", 1))

    with Path(htt / json_filename).open("w+") as json_file:
        bottle_json = json.load(json_file)

        bottle_json[next(iter(bottle_json))]["bottle"]["tags"][f"arm64_{osx}"] = \
            bottle_json[next(iter(bottle_json))]["bottle"]["tags"][osx]

        json.dump(bottle_json, json_file)

print(" ".join(map(str, assets)))
