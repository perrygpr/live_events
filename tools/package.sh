#!/bin/sh

pushd $(dirname $0) > /dev/null
cd ..

target="/tmp/$(basename $(pwd))-$(git show | head -n1 | cut -c8-14)"
if [ -f ${target}.zip ]; then
    echo "Removing existing file: ${target}.zip"
    rm ${target}.zip
fi
zip -r $target . -x .git/\* .gitignore tmp/\* tools/\* \*.swp
if [ -f ${target}.zip ]; then
    echo "Successfully created ${target}.zip"
else
    echo "Failed to create ${target}.zip"
fi

popd > /dev/null
