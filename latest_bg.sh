#!/bin/sh

ROOT=/home/jbalint/sw/java-sw/nightscout-virtual-graph
QUERY=$(cat $ROOT/latest_sgv.rq)

source /home/jbalint/sw/banshee-sympatico/percy/curl-params.sh

VAL=$(curl $CURL_PARAMS -s -H "Accept: application/sparql-results+json" -G https://jessandmorgan.com/stardog/bs/query \
         --data-urlencode query="$QUERY" | \
          jq '.results.bindings[0].sgv.value' | sed 's/\"//g')

# The relationship between A1C and eAG is described by the formula 28.7 X A1C – 46.7 = eAG.
# A1C = (eAG + 46.7) / 28.7

perl -e "printf(\"%dmg/dL %.01fmmol/L %.01f%%\n\", $VAL, ($VAL/18.0), ($VAL+46.7)/28.7)"
