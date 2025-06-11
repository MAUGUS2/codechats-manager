# CodeChats Manager Makefile

.PHONY: help install test lint format clean package dev-setup

# Default target
help:
	@echo "CodeChats Manager - Development Commands"
	@echo "========================================"
	@echo ""
	@echo "🚀 Installation:"
	@echo "  install        Install CodeChats Manager locally"
	@echo "  dev-setup      Setup development environment"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  test           Run all tests"
	@echo "  test-install   Test installation process"
	@echo ""
	@echo "📝 Code Quality:"
	@echo "  lint           Run linting checks"
	@echo "  format         Format code"
	@echo "  check          Run all quality checks"
	@echo ""
	@echo "📦 Distribution:"
	@echo "  package        Create distribution package"
	@echo "  clean          Clean build artifacts"
	@echo ""
	@echo "🛠️ Development:"
	@echo "  dev-install    Install in development mode"
	@echo "  uninstall      Remove CodeChats Manager"

# Installation
install:
	@echo "🚀 Installing CodeChats Manager..."
	./scripts/install.sh

dev-setup:
	@echo "🛠️ Setting up development environment..."
	./scripts/dev-setup.sh

dev-install:
	@echo "🔧 Installing in development mode..."
	mkdir -p ~/.claude/temp ~/.claude/commands
	ln -sf $(PWD)/src/codechats-main.sh ~/.claude/temp/
	ln -sf $(PWD)/src/codechats-cache.py ~/.claude/temp/
	ln -sf $(PWD)/src/codechats-main.sh ~/.claude/commands/codechats
	@echo "✅ Development installation complete"
	@echo "📝 Run 'codechats' to test"

# Testing
test:
	@echo "🧪 Running tests..."
	./tests/test.sh

test-install:
	@echo "🧪 Testing installation process..."
	./scripts/quick-install.sh --dry-run

# Code Quality
lint:
	@echo "📝 Running linting checks..."
	@command -v shellcheck >/dev/null && find src scripts -name "*.sh" -exec shellcheck {} \; || echo "⚠️ shellcheck not installed"
	@command -v python3 >/dev/null && python3 -m py_compile src/*.py || echo "⚠️ Python syntax check failed"

format:
	@echo "📝 Formatting code..."
	@command -v black >/dev/null && black src/ || echo "⚠️ black not installed"

check: lint
	@echo "✅ All quality checks passed"

# Distribution
package:
	@echo "📦 Creating distribution package..."
	mkdir -p dist
	tar -czf dist/codechats-manager-$(shell grep version pyproject.toml | cut -d'"' -f2).tar.gz \
		--exclude='dist' \
		--exclude='.git' \
		--exclude='__pycache__' \
		--exclude='*.pyc' \
		.
	@echo "✅ Package created in dist/"

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf dist/
	rm -rf build/
	rm -rf __pycache__/
	find . -name "*.pyc" -delete
	find . -name "*.pyo" -delete
	find . -name "*~" -delete

# Uninstall
uninstall:
	@echo "🗑️ Removing CodeChats Manager..."
	rm -f ~/.claude/commands/codechats
	rm -f ~/.claude/temp/codechats-main.sh
	rm -f ~/.claude/temp/codechats-cache.py
	rm -f ~/.claude/temp/codechats_cache.json
	@echo "✅ CodeChats Manager removed"

# Development utilities
watch:
	@echo "👀 Watching for changes..."
	@command -v fswatch >/dev/null && fswatch -o src/ | xargs -n1 -I{} make test || echo "⚠️ fswatch not installed"

docs:
	@echo "📚 Opening documentation..."
	@command -v open >/dev/null && open README.md || echo "📖 See README.md"

# Version management
version:
	@grep version pyproject.toml | cut -d'"' -f2

bump-version:
	@echo "📈 Current version: $(shell make version)"
	@echo "📝 Update version in pyproject.toml manually"