#!/bin/bash

# Simple test script for CodeChats Manager
# Just checks that files exist and are executable

set -e

echo "🧪 Basic CodeChats Manager validation..."

# Check that main files exist
[ -f "src/codechats-main.sh" ] || { echo "❌ Main script missing"; exit 1; }
[ -f "src/codechats-cache.py" ] || { echo "❌ Cache script missing"; exit 1; }
[ -x "src/codechats-main.sh" ] || { echo "❌ Main script not executable"; exit 1; }

echo "✅ All files present and executable"
echo "🎉 Ready for installation!"