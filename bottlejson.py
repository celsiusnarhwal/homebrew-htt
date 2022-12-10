import json
import subprocess
import sys
from pathlib import Path


def dump():
    json_file = next(Path.cwd().glob('*.json'), None)

    if not json_file:
        sys.exit("No bottle JSON found.")

    bottle = json.load(json_file.open())

    formula_info = next(iter(bottle.values()))["formula"]
    bottle_info = next(iter(bottle.values()))["bottle"]
    build_info = next(iter(bottle_info["tags"].values()))

    metadata = ({
        "bottle": build_info["local_filename"],
        "root_url": bottle_info["root_url"].lstrip("https://"),
        "title": formula_info["name"],
        "source": formula_info["homepage"],
        "version": formula_info["pkg_version"],
        "description": formula_info["desc"],
        "licenses": formula_info["license"],
        "authors": "celsius narhwal",
    })

    print(json.dumps(metadata))

    # tag = f"{metadata['root_url']}/{metadata['title']}:{metadata['version']}"
    # build_args = "".join(f'--build-arg {key.upper()}="{value}" ' for key, value in metadata.items()) + f"-t {tag}"

    # subprocess.run(f"docker build {build_args} .", shell=True)
    # subprocess.run(f"docker push {tag}", shell=True)


if __name__ == "__main__":
    dump()
