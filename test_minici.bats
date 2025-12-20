#!/usr/bin/env bats

setup() {
	# Make sure minici is executable
	chmod +x ./minici
}

teardown() {
	# Clean up any test files
	rm -f test_file.tmp
	# Kill any running minici processes
	pkill -f "minici true" || true
}

@test "shows help with --help flag" {
	run ./minici --help
	[ "$status" -eq 1 ]
	[[ "$output" == *"Usage:"* ]]
	[[ "$output" == *"pytest"* ]]
}

@test "shows help with -h flag" {
	run ./minici -h
	[ "$status" -eq 1 ]
	[[ "$output" == *"Usage:"* ]]
}

@test "fails with no arguments" {
	run ./minici
	[ "$status" -eq 1 ]
	[[ "$output" == *"Usage:"* ]]
}

@test "fails with nonexistent command" {
	run ./minici nonexistent_command_12345
	[ "$status" -eq 1 ]
	[[ "$output" == *"Command not found"* ]]
}

@test "passes shellcheck validation" {
	if ! command -v shellcheck >/dev/null; then
		skip "shellcheck not available"
	fi
	run shellcheck ./minici
	[ "$status" -eq 0 ]
}

@test "handles narrow terminal width" {
	# Start minici in background with narrow terminal
	COLUMNS=10 timeout 2s ./minici true &
	sleep 0.5

	# Trigger file change
	echo "test" >test_file.tmp
	sleep 0.5

	# Should not crash (process cleanup in teardown)
}
