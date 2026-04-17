#!/bin/bash

echo "Getting files"

curl -C - -fLO http://folkets-lexikon.csc.kth.se/folkets/folkets_en_sv_public.xml
rc=$?; [ $rc -eq 0 ] || [ $rc -eq 33 ] || exit $rc

curl -C - -fLO http://folkets-lexikon.csc.kth.se/folkets/folkets_sv_en_public.xml
rc=$?; [ $rc -eq 0 ] || [ $rc -eq 33 ] || exit $rc

echo "Got all files"

