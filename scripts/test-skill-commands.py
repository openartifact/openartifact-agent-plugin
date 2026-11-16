#!/usr/bin/env python3
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
"""Run the shell commands of the check-lockfile skill against real lockfiles.

Every ```sh block of skills/check-lockfile/SKILL.md that reads a lockfile is
named by the label above it: "extract:<file>" for the blocks that list the
pinned versions, "requires:<file>" for those that find what requires PACKAGE
(a Yarn block adds "@1" or "@2" for its version). tests/skill-commands.json
gives each block one or more cases: a fixture from tests/lockfiles, copied
under the file name the command reads, and the output it must give (the
package@version list of an extraction, the sorted lines of a requirers
lookup). A block without a case, or a case without a block, fails: a command
cannot be added or renamed untested.

The commands run as the skill shows them, with the awk, jq, sed, tr and sort
of the machine, so CI runs this where those differ (mawk and jq 1.6 on Ubuntu
22.04, BSD awk on macOS).

  python3 scripts/test-skill-commands.py          run the cases
  python3 scripts/test-skill-commands.py --print  show what every case gives
"""

import json
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
SKILL = ROOT / "skills" / "check-lockfile" / "SKILL.md"
CASES = ROOT / "tests" / "skill-commands.json"
FIXTURES = ROOT / "tests" / "lockfiles"

BLOCK = re.compile(r"(?m)^[ \t]*(\S[^\n]*)\n\n[ \t]*```sh\n(.*?)^[ \t]*```", re.S)
LOCKFILE = re.compile(r"`([^`]*\.(?:lock|json|yaml))`")


def blocks():
    """The lockfile command blocks of the skill by name, dedented."""
    out = {}
    for m in BLOCK.finditer(SKILL.read_text(encoding="utf-8")):
        label, body = m.group(1), m.group(2)
        file = LOCKFILE.search(label)
        if not file:
            continue
        name = ("requires:" if "PACKAGE" in body else "extract:") + file.group(1)
        for version in ("1", "2"):
            if name.startswith("extract:") and f"Yarn {version}" in label:
                name += "@" + version
        if name in out:
            sys.exit(f"two blocks are named {name}")
        out[name] = re.sub(r"(?m)^   ", "", body)
    return out


def run(command, fixture, lockfile, package):
    """Runs command in a directory holding fixture as lockfile; its stdout."""
    with tempfile.TemporaryDirectory() as tmp:
        shutil.copy(FIXTURES / fixture, pathlib.Path(tmp) / lockfile)
        if package is not None:
            command = command.replace("PACKAGE", package)
        res = subprocess.run(
            ["bash", "-o", "pipefail", "-c", command],
            cwd=tmp, capture_output=True, text=True, timeout=60, check=False,
        )
    if res.returncode != 0:
        raise RuntimeError(f"exit {res.returncode}: {res.stderr.strip()}")
    return res.stdout


def result(name, output):
    """The comparable form of a block's output."""
    if name.startswith("extract:"):
        return sorted(f"{p['package']}@{p['version']}" for p in json.loads(output))
    return sorted(line for line in output.splitlines() if line.strip())


def main():
    show = "--print" in sys.argv[1:]
    found = blocks()
    cases = json.loads(CASES.read_text(encoding="utf-8"))
    failures = []

    for name in sorted(set(found) - {c["block"] for c in cases}):
        failures.append(f"{name}: no case in {CASES.relative_to(ROOT)}")

    for case in cases:
        name = case["block"]
        if name not in found:
            failures.append(f"{name}: no such block in {SKILL.relative_to(ROOT)}")
            continue
        lockfile = name.split(":", 1)[1].split("@")[0]
        what = f"{name} on {case['fixture']}" + (f" ({case['package']})" if "package" in case else "")
        try:
            got = result(name, run(found[name], case["fixture"], lockfile, case.get("package")))
        except (RuntimeError, ValueError, KeyError, TypeError) as err:
            failures.append(f"{what}: {err}")
            continue
        if show:
            print(f"{what}:\n  {json.dumps(got)}")
        elif got != sorted(case["want"]):
            failures.append(f"{what}:\n  got  {got}\n  want {sorted(case['want'])}")

    for f in failures:
        print("FAIL", f)
    if failures:
        return 1
    if not show:
        print(f"{len(cases)} cases of {len(found)} skill commands pass")
    return 0


if __name__ == "__main__":
    sys.exit(main())
