#!/bin/sh
_OUT=dist/starphase.love
rm ${_OUT}; zip -9 -r --exclude=*.git* ${_OUT} . && echo "created ${_OUT}"
