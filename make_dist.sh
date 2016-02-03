#!/bin/sh
_OUT=dist/starphase.love
zip -9 -q -r ${_OUT} . && echo "created ${_OUT}"
