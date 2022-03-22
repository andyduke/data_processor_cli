#!/bin/bash

pushd $(dirname $(readlink -f $0))/binary

../build.sh
tar -czvf ../dp-linux.tgz dp

popd
