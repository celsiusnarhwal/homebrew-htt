import shutil
import sys
from pathlib import Path

bottle, platform = Path(sys.argv[1]).rename(sys.argv[1].replace("--", "-")).resolve(), sys.argv[2]

assets = [bottle]

# GitHub's macOS runners currently only support Intel architecture so we need to duplicate and rename macOS
# bottles for Apple silicon.
if "macos" in platform:
    osx = {"macos-11": "big_sur", "macos-12": "monterey"}[platform]
    assets.append(Path(shutil.copy(bottle, bottle.name.replace(osx, f"arm64_{osx}"))).resolve())

print(" ".join(map(str, assets)))
