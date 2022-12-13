# Merge bottle JSON files and commit changes to formulae.

import json
import subprocess
import sys
from pathlib import Path

formula = sys.argv[1]
bottle_jsons = list(Path.cwd().glob(f"**/{formula}*.json"))
final = json.load(bottle_jsons.pop().open())

subprocess.run(["brew", "install", f"celsiusnarhwal/htt/{formula}"])

while bottle_jsons:
    json_file = bottle_jsons.pop()
    bottle_json = json.load(json_file.open())
    final[next(iter(final))]["bottle"]["tags"].update(bottle_json[next(iter(bottle_json))]["bottle"]["tags"])
    json_file.unlink()

final_path = Path(f"{formula}.json").resolve()

json.dump(final, final_path.open("w"))

subprocess.run(["brew", "bottle", "--merge", "--write", final_path])
