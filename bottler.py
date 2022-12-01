import argparse
import json
from pathlib import Path


def main(bottle_json: str):
    bottle = json.load(open(bottle_json))
    formula_name = list(bottle.keys())[0]
    build_tag = list(bottle[formula_name]["bottle"]["tags"].keys())[0]

    bottle[formula_name]["bottle"]["tags"]["all"] = bottle[formula_name]["bottle"]["tags"][build_tag]
    bottle[formula_name]["bottle"]["tags"].pop(build_tag)

    json.dump(bottle, open(bottle_json, "w"), indent=4)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("json", help="bottle json to parse")
    args = parser.parse_args()
    main(args.json)
