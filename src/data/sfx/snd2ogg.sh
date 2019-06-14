#!/bin/sh
for i in *.{wav,mp3,m4a}; do ffmpeg -i $i ${i%.*}.ogg && rm -f $i; done
