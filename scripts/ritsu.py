import json
import sys
from pathlib import Path

htt = Path(__file__).parent.parent
formula = sys.argv[1]
bottle_jsons = list(htt.glob(f"{formula}*.json"))

final = json.load(bottle_jsons.pop().open())

while bottle_jsons:
    json_file = bottle_jsons.pop()
    bottle_json = json.load(json_file.open())
    final[next(iter(final))]["bottle"]["tags"].update(bottle_json[next(iter(bottle_json))]["bottle"]["tags"])
    json_file.unlink()

json.dump(final, (htt / f"{formula}.json").open("w+"))

print(Path(htt / f"{formula}.json").resolve())
