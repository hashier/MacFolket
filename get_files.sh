#!/bin/bash

echo "Getting files"

curl -fLO http://folkets-lexikon.csc.kth.se/folkets/folkets_en_sv_public.xml
curl -fLO http://folkets-lexikon.csc.kth.se/folkets/folkets_sv_en_public.xml

echo "Got all files"

