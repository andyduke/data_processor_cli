#!/bin/bash

ROOT=$(dirname $(readlink -f $0))

pushd $ROOT/..
dart compile exe -o $ROOT/binary/dp bin/data_processor.dart
popd
