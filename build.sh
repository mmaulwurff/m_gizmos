#!/bin/bash

set -e

name=m_gizmos-$(git describe --abbrev=0 --tags).pk3

rm -f "$name"

zip -R "$name" \
    "*.lmp" \
    "*.md"  \
    "*.txt" \
    "*.wav" \
    "*.zs"

gzdoom -file "$name" "$@"
