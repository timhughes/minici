# minici

A cross-platform file watcher and test runner for continuous integration during local development.

## Description

`minici` is a lightweight bash script that monitors your project directory for file changes and automatically executes commands (like running tests) whenever changes are detected. It works on both Linux (using `inotifywait`) and macOS (using `fswatch`), providing continuous feedback during development by automatically running your test suite or build process when you save files.

## Features

- 🔍 **Cross-platform file watching** - Uses `inotifywait` on Linux, `fswatch` on macOS
- 🚀 Automatically runs specified commands on file save
- 🎯 Respects `.gitignore` patterns dynamically
- 📝 Filters out temporary files and common build artifacts
- 🧹 Preserves output history for tracking changes
- ⏱️ Debounces rapid file changes to avoid duplicate runs
- 🎨 Colored output with centered header display
- ❌ Error handling with exit code reporting

## Requirements

### Linux
- `bash`
- `inotify-tools` (provides `inotifywait`)

### macOS
- `bash`
- `fswatch`

### Installing Dependencies

**Linux - Debian/Ubuntu:**
```bash
sudo apt-get install inotify-tools
```

**Linux - Fedora/RHEL/CentOS:**
```bash
sudo yum install inotify-tools
```

**Amazon Linux 2:**
```bash
sudo yum install https://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/i/inotify-tools-3.14-9.el7.x86_64.rpm
```

**macOS:**
```bash
brew install fswatch
```

**Note:** The script automatically detects which file watcher is available and uses the appropriate one.

## Installation

1. Clone or download the `minici` script:
```bash
wget https://raw.githubusercontent.com/timhughes/minici/main/minici
chmod +x minici
```

2. Optionally, move it to your PATH:
```bash
sudo mv minici /usr/local/bin/
```

Or keep it in your project directory and run it with `./minici`.

## Usage

Basic syntax:
```bash
./minici <command> [arguments...]
```

### Examples

**Run pytest on file changes:**
```bash
./minici pytest
```

**Run pytest with specific options:**
```bash
./minici pytest -v tests/
```

**Run a custom build script:**
```bash
./minici npm test
```

**Run multiple commands:**
```bash
./minici sh -c "npm run lint && npm test"
```

**Run Python unit tests:**
```bash
./minici python -m unittest discover
```

### How It Works

1. `minici` starts monitoring the current directory (recursively)
2. When a file is saved (`close_write` event), it checks:
   - Is the event recent? (within 1 second to debounce)
   - Is the file not in `.git` directory?
   - Is the file not ignored by `.gitignore`?
   - Does the file not match common temporary file patterns?
3. If all checks pass, it clears the screen and runs your command
4. The output is displayed, and monitoring continues

### Excluded Files

The following patterns are automatically excluded from triggering runs:
- Hidden editor files (`.*.swp`, `.*.swx`)
- Git lock files
- Build directories
- Log files
- pytest cache
- Coverage files
- And more (see `EXCLUDE_REGEX` in the script)

## Configuration

You can customize the behavior by editing the script variables:

- `STALE_EVENT_SECS`: Time window for debouncing events (default: 1 second)
- `EXCLUDE_REGEX`: Pattern for files to ignore

## License

MIT License

Copyright (C) 2015 Tim Hughes <thughes@thegoldfish.org>

## Author

Tim Hughes - <thughes@thegoldfish.org>

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.
