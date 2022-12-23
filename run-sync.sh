#!/usr/bin/env bash

for dir in $@; do
    pushd .
    cd "$dir"
    if ! test -d .git; then
        echo >&2 "$dir is not a git repository; skipping"
        continue
    fi
    git add *
    git commit -a -m "Autocommit: $(hostname -s)@$(date -Iseconds)"
    git push
    popd
done
