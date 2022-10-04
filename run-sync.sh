#!/usr/bin/env fish

for dir in $argv
    pushd .
    cd "$dir"
    if test ! -d .git
        echo >&2 "$dir is not a git repository; skipping"
        continue
    end
    git add *
    git commit -a -m "Autocommit: $(hostname -s)@$(date -Iseconds)"
    git push
    popd
end
