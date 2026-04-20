#!/usr/bin/env python3
"""
Post-process xsltproc output to fix ampersand encoding in MacFolket.xml.

WHY THIS EXISTS:
  The Folkets source XML uses &amp;#39; and &amp;quot; to encode apostrophes
  and quotes (~5 200 and ~13 200 occurrences respectively). These are
  double-encoded: the XML parser reads &amp; as a literal & character, leaving
  the text &#39; or &quot; as five/six plain characters rather than as XML
  character references. xsltproc faithfully re-encodes that literal & back to
  &amp; in its output, so the Apple Dictionary build tool would display the
  text &#39; and &quot; on screen instead of ' and ".

WHAT IT DOES (two steps):
  1. Replace every &amp; with & — this collapses the double-encoding so that
     &#39; and &quot; become proper XML character/entity references again.
  2. Re-escape any & that is NOT the start of a valid XML reference, i.e. any
     & not followed by name; (named entity) or #digits; or #xhex; (char refs).
     This covers bare ampersands in content like "R&D" or grammar notes "A &"
     that step 1 would otherwise leave as invalid XML.

NET EFFECT:
  &amp;#39;  -> &#39;   (renders as ')
  &amp;quot; -> &quot;  (renders as ")
  &amp;       -> &amp;   (round-trip, no visible change)
  R&amp;D    -> R&amp;D (round-trip, renders as R&D)
"""

import re
import sys

path = sys.argv[1] if len(sys.argv) > 1 else "MacFolket.xml"
content = open(path).read()

# Step 1: collapse double-encoded &amp; -> &
content = content.replace("&amp;", "&")

# Step 2: re-escape & not followed by a valid XML named entity, decimal char
# ref (#NNN;), or hex char ref (#xHHH;)
content = re.sub(
    r"&(?!(?:[a-zA-Z][a-zA-Z0-9]*|#[0-9]+|#x[0-9a-fA-F]+);)",
    "&amp;",
    content,
)

open(path, "w").write(content)
