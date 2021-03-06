#!/bin/bash

set -e -x -o pipefail

# test for successful release build
dub build --combined -b release --compiler=$DC

# test for successful 32-bit build
if [ "$DC" == "dmd" ]; then
	dub build --combined --arch=x86
fi

dub test --combined --compiler=$DC

if [ ${BUILD_EXAMPLE=1} -eq 1 ]; then
    for ex in $(\ls -1 examples/*.d); do
        echo "[INFO] Building example $ex"
        dub build --compiler=$DC --single $ex
    done
    rm -rf examples/.dub/
    rm examples/*-example
fi
if [ ${RUN_TEST=1} -eq 1 ]; then
    for ex in `\ls -1 tests/*.d`; do
        echo "[INFO] Running test $ex"
        dub --temp-build --compiler=$DC --single $ex
    done
fi
