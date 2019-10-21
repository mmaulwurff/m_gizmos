#!/bin/bash

#IWAD=~/Programs/Games/wads/iwads/freedoom1.wad
#IWAD=~/Programs/Games/wads/iwads/DOOM.WAD
#IWAD=~/Programs/Games/wads/iwads/HERETIC.WAD
#IWAD=~/Programs/Games/wads/modules/game/harm1.wad

name=m_gizmos
version=$(git describe --abbrev=0 --tags)
filename=$name-$version.pk3

rm -f $filename \
&& \
zip $filename    \
    sounds/*.wav \
    sounds/*.lmp \
    zscript/*.zs \
    *.md  \
    *.txt \
    *.zs  \
&& \
gzdoom -iwad $IWAD \
       -file $filename \
       ~/Programs/Games/wads/maps/test/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
