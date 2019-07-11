#!/usr/bin/env bash

# Store original terminal dimensions.
COLS="$(tput cols)"
ROWS="$(tput lines)"

# Set fixed terminal size for recording.
stty columns 80
stty rows 30

# Record.
asciinema rec rec.cast --command="vim -u plugin.vim src/Main.elm"

# Restore original terminal dimensions.
stty columns "$COLS"
stty rows "$ROWS"
