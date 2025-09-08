# Neovim Configuration Documentation

## Overview
This Neovim configuration provides a comprehensive development environment with support for multiple programming languages, with enhanced Python support. The configuration is built using Lazy.nvim for plugin management and focuses on performance, maintainability, and developer productivity.

## Architecture

### Plugin Structure
- `lua/plugins/` - Contains all plugin configurations
- `init.lua` - Main configuration entry point
- `lua/vim-options.lua` - Vim options and settings

### Key Plugin Files

#### 1. Language Support
- **`lsp-config.lua`** - Language Server Protocol configurations
- **`none-ls.lua`** - Additional formatting and linting
- **`mason-tools.lua`** - Automatic tool installation

#### 2. Python Development
- **`python.lua`** - Python-specific debugging, testing, and REPL tools

#### 3. UI and Navigation
- **`themes.lua`** - Color schemes and themes
- **`neo-tree.lua`** - File explorer
- **`telescope.lua`** - Fuzzy finding
- **`lualine.lua`** - Status line

#### 4. Development Tools
- **`completions.lua`** - Code completion
- **`treesitter.lua`** - Syntax highlighting
- **`toggleterm.lua`** - Terminal management

## Python Development Features

### Enhanced LSP Configuration
- **Pyright**: Type checking and IntelliSense with strict mode
- **Ruff**: Fast linting and formatting (replaces black, isort, flake8)
- **Automatic venv detection**: Automatically detects and uses virtual environments

### Key Improvements Made
1. **Eliminated Redundancies**:
   - Removed duplicate ruff configuration between LSP and null-ls
   - Consolidated Python formatting under ruff LSP
   - Removed duplicate tool installations

2. **Optimized Toolchain**:
   - Ruff handles both linting and formatting
   - Removed redundant black and isort installations
   - Simplified configuration structure

3. **Enhanced Documentation**:
   - Added comprehensive type annotations
   - Documented all functions and configurations
   - Added inline comments explaining purpose

### Debugging Support
- **nvim-dap**: Full Python debugging with debugpy
- **nvim-dap-ui**: Visual debugging interface
- **nvim-dap-virtual-text**: In-line variable values
- Keymaps: `<leader>db` (breakpoint), `<leader>dc` (continue)

### Testing Integration
- **neotest**: Unified testing with pytest support
- Keymaps: `<leader>tt` (run file tests), `<leader>tn` (run nearest test)

### REPL Integration
- **iron.nvim**: Interactive Python REPL
- Keymaps: `<leader>rc` (send to REPL), `<leader>rf` (send file)

### Auto-Format Feature
- **Automatic formatting**: Python files are automatically formatted on save using Ruff
- **Toggle functionality**: Can be enabled/disabled on demand
- **Manual formatting**: Format current buffer manually
- **Smart detection**: Only formats when Ruff LSP is available
- **User commands**: `PythonFormatToggle`, `PythonFormat`, `PythonFormatEnable`, `PythonFormatDisable`

## Configuration Keymaps

### LSP Navigation
- `K` - Show hover documentation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Go to references
- `gt` - Go to type definition

### LSP Actions
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code
- `<leader>cd` - Show diagnostics

### Formatting
- `<leader>gf` - Format code
- `<leader>gF` - Format and save

### Debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue debugging
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dO` - Step out
- `<leader>du` - Toggle DAP UI

### Testing
- `<leader>tt` - Run current file tests
- `<leader>tn` - Run nearest test
- `<leader>ts` - Toggle test summary
- `<leader>to` - Open test output

### REPL
- `<leader>rc` - Send to REPL
- `<leader>rf` - Send file to REPL
- `<leader>rl` - Send line to REPL
- `<leader>rq` - Quit REPL

### Auto-Format (Python)
- `<leader>af` - Toggle auto-format on save
- `<leader>aF` - Manually format current Python buffer
- `<leader>ae` - Enable auto-format
- `<leader>ad` - Disable auto-format

## Installation and Setup

### Prerequisites
- Neovim 0.9+ with Lua support
- Python 3.8+ with pip
- Node.js (for some web development tools)

### Automatic Installation
The configuration uses Mason to automatically install all required tools:
- Language servers (pyright, ruff, etc.)
- Debuggers (debugpy)
- Test runners (pytest)
- Formatters and linters

### Manual Dependencies
```bash
# Python dependencies
pip install python-lsp-server[all] debugpy pytest

# Optional: Additional Python tools
pip install black isort flake8 mypy
```

## Configuration Files Summary

### Core Files
- `init.lua` - Main entry point with lazy.nvim setup
- `vim-options.lua` - Basic Vim options and settings

### Plugin Files
- `lsp-config.lua` - LSP configurations with enhanced Python support
- `none-ls.lua` - Additional formatting and linting
- `mason-tools.lua` - Automatic tool installation
- `python.lua` - Python-specific development tools
- `completions.lua` - Code completion setup
- `treesitter.lua` - Syntax highlighting
- `themes.lua` - Color schemes
- `neo-tree.lua` - File explorer
- `telescope.lua` - Fuzzy finding
- `lualine.lua` - Status line
- `toggleterm.lua` - Terminal management

## Performance Optimizations

1. **Lazy Loading**: All plugins are loaded on demand
2. **Tree-sitter**: Faster syntax highlighting
3. **Ruff**: Replaces multiple tools with one fast solution
4. **Mason**: Automatic management of language servers

## Maintenance

### Adding New Languages
1. Add language server to `lsp-config.lua`
2. Add tools to `mason-tools.lua`
3. Add treesitter parsers in `treesitter.lua`
4. Add any language-specific configurations

### Updating Tools
- Tools are automatically updated by Mason
- Configuration is centralized and documented
- Type annotations help with maintenance

## Troubleshooting

### Common Issues
1. **LSP not working**: Check Mason installation and restart Neovim
2. **Python path issues**: Ensure virtual environments are properly detected
3. **Formatting not working**: Verify Ruff LSP is installed and configured
4. **Debugging issues**: Check debugpy installation and Python path

### Debug Commands
- `:Mason` - Check installed tools
- `:LspInfo` - Check LSP status
- `:lua print(vim.lsp.get_active_clients())` - List active LSP clients