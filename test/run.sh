#!/bin/bash

set -e

PATH=$DART_SDK/chromium:$PATH
results='DumpRenderTree index.html 2>&1'

echo "$results" | grep CONSOLE
echo $results | grep -v 'Exception: Some tests failed.' >/dev/null
