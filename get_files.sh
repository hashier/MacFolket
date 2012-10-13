#!/bin/bash

echo "Getting files"

curl -C - -sS -o folkets_sv_en_public.xml http://folkets-lexikon.csc.kth.se/folkets/folkets_en_sv_public.xml
 curl -C - -sS -o folkets_en_sv_public.xml http://folkets-lexikon.csc.kth.se/folkets/folkets_sv_en_public.xml

 echo "Got all files"

