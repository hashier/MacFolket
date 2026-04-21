#!/usr/bin/env python3
"""
Integration tests for MacFolket.xsl.

Transforms small.xml (the source before transform) and asserts expected
content in the resulting output (the equivalent of MacFolket.xml).

Each test looks up a specific entry by headword and checks that a substring
appears in it — e.g. that "asleep" renders "Word class: adverb, adjektiv".
"""

import re
import subprocess
import sys

PASS = 0
FAIL = 0


def transform(source: str) -> str:
    result = subprocess.run(
        ["xsltproc",
         "--stringparam", "version", "test",
         "--stringparam", "buildDate", "test",
         "MacFolket.xsl", source],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"xsltproc failed:\n{result.stderr}")
        sys.exit(1)
    return result.stdout


def entry(output: str, word: str) -> str:
    """Return the content of the <d:entry> with d:title matching word."""
    m = re.search(
        rf'd:title="{re.escape(word)}"[^>]*>(.*?)</d:entry>',
        output, re.DOTALL,
    )
    return m.group(1) if m else ""


def assert_in(label: str, output: str, word: str, expected: str):
    global PASS, FAIL
    content = entry(output, word)
    if not content:
        print(f"  FAIL  {label}  (no entry found for {word!r})")
        FAIL += 1
        return
    if expected in content:
        print(f"  PASS  {label}")
        PASS += 1
    else:
        print(f"  FAIL  {label}")
        print(f"        word:     {word!r}")
        print(f"        expected: {expected!r}")
        for line in content.splitlines():
            line = line.strip()
            if line:
                print(f"        content:  {line!r}")
        FAIL += 1


# ---------------------------------------------------------------------------
# Transform once, test everything against that output
# ---------------------------------------------------------------------------
output = transform("small.xml")

# ---------------------------------------------------------------------------
# Word class: single codes
# Each word comes from the test fixtures added to small.xml
# ---------------------------------------------------------------------------
print("Single class codes:")
assert_in("article",   output, "den",             "Word class: artikel")
assert_in("hjälpverb", output, "be",              "Word class: hjälpverb")
assert_in("hp",        output, "vilket",          "Word class: fråge-/relativpronomen")
assert_in("ie",        output, "att",             "Word class: infinitivmärke")
assert_in("kn",        output, "allteftersom",    "Word class: konjunktion")
assert_in("latin",     output, "id est",          "Word class: latin")
assert_in("pc",        output, "ablate",          "Word class: particip")
assert_in("pm",        output, "Försäkringskassan","Word class: egennamn")
assert_in("prefix",    output, "aero-",           "Word class: prefix")
assert_in("ps",        output, "någons",          "Word class: possessivt pronomen")
assert_in("ro",        output, "eighteenth",      "Word class: ordningstal")
assert_in("sn",        output, "utifall",         "Word class: subjunktion")
assert_in("suffix",    output, "-procentig",      "Word class: suffix")
# Classes already present in original small.xml
assert_in("abbrev",    output, "ABF",             "Word class: förkortning")
assert_in("nn",        output, "bil",             "Word class: substantiv")
assert_in("vb",        output, "abdikera",        "Word class: verb")

# ---------------------------------------------------------------------------
# Word class: compound codes
# ---------------------------------------------------------------------------
print("\nCompound class codes:")
assert_in("ab, jj",    output, "asleep",          "Word class: adverb, adjektiv")
assert_in("ab, kn",    output, "when",            "Word class: adverb, konjunktion")
assert_in("ab, pn",    output, "there",           "Word class: adverb, pronomen")
assert_in("ab, pp",    output, "as",              "Word class: adverb, preposition")
assert_in("abbrev, nn",output, "BBC",             "Word class: förkortning, substantiv")
assert_in("jj, ab",    output, "dryshod",         "Word class: adjektiv, adverb")
assert_in("jj, nn",    output, "above",           "Word class: adjektiv, substantiv")
assert_in("jj, pc",    output, "dotted",          "Word class: adjektiv, particip")
assert_in("jj, pp",    output, "unlike",          "Word class: adjektiv, preposition")
assert_in("nn, jj",    output, "Tory",            "Word class: substantiv, adjektiv")
assert_in("nn, vb",    output, "bounce",          "Word class: substantiv, verb")
assert_in("pp, ab",    output, "below",           "Word class: preposition, adverb")
assert_in("pp, kn",    output, "until",           "Word class: preposition, konjunktion")
assert_in("rg, nn",    output, "eighty",          "Word class: grundtal, substantiv")
assert_in("ro, nn",    output, "eighth",          "Word class: ordningstal, substantiv")
assert_in("vb, nn",    output, "copy-and-paste",  "Word class: verb, substantiv")

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total = PASS + FAIL
print(f"\n{PASS}/{total} passed", end="")
if FAIL:
    print(f", {FAIL} FAILED")
    sys.exit(1)
else:
    print()
