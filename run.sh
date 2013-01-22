#!/bin/bash

set -e

PATH=$HOME/local/dart/chromium:$PATH
results='DumpRenderTree test/index.html 2>&1'

echo "$results" | grep CONSOLE
echo $results | grep -v 'Exception: Some tests failed.' >/dev/null
