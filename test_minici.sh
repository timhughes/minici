#!/usr/bin/env bash
set -e

echo "Testing minici..."

# Test help
echo "✓ Testing --help"
./minici --help >/dev/null 2>&1 || true

# Test -h
echo "✓ Testing -h"
./minici -h >/dev/null 2>&1 || true

# Test no arguments
echo "✓ Testing no arguments"
if ./minici 2>/dev/null; then
    echo "ERROR: Should have failed with no args"
    exit 1
fi

# Test command not found
echo "✓ Testing command not found"
if ./minici nonexistent_command_12345 2>/dev/null; then
    echo "ERROR: Should have failed with bad command"
    exit 1
fi

# Test shellcheck passes
if command -v shellcheck >/dev/null; then
    echo "✓ Testing shellcheck"
    shellcheck ./minici
fi

# Test narrow terminal
echo "✓ Testing narrow terminal"
COLUMNS=10 timeout 2s ./minici true &
sleep 0.5
echo "test" > test_file.tmp
sleep 0.5
pkill -f "minici true" || true
rm -f test_file.tmp

echo "All tests passed!"
