#!/usr/bin/env bash

# Remove old recording
rm -f rec.cast

# Store original terminal dimensions.
COLS="$(tput cols)"
ROWS="$(tput lines)"

# Set fixed terminal size for recording.
stty columns 80
stty rows 30

# Create backup
cp src/Main.elm Main.elm.backup

# Record.
asciinema rec rec.cast --command="vim -u plugin.vim src/Main.elm"

# Restore backup
mv Main.elm.backup src/Main.elm

# Restore original terminal dimensions.
stty columns "$COLS"
stty rows "$ROWS"
