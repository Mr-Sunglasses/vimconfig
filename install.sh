#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

check_prerequisites() {
  command -v git &>/dev/null   || error "git is not installed"
  command -v nvim &>/dev/null  || error "neovim is not installed"
  command -v curl &>/dev/null  || error "curl is not installed"

  if ! command -v gcc &>/dev/null; then
    warn "gcc is not installed, installing..."
    if [[ "$(uname)" == "Darwin" ]]; then
      xcode-select --install
    elif command -v apt &>/dev/null; then
      sudo apt install -y gcc g++ make
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y gcc gcc-c++ make
    elif command -v pacman &>/dev/null; then
      sudo pacman -S --noconfirm gcc make
    else
      error "Could not detect package manager, please install gcc manually"
    fi
  fi
}

check_prerequisites

NVIM_DIR="${HOME}/.config/nvim"

if [ -d "${NVIM_DIR}" ]; then
  BACKUP="${NVIM_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
  warn "Existing nvim config found, backing up to ${BACKUP}"
  mv "${NVIM_DIR}" "${BACKUP}"
fi

mkdir -p "${NVIM_DIR}"

info "Cloning config..."
git clone https://github.com/Mr-Sunglasses/vimconfig "${NVIM_DIR}"

info "Installing plugins..."
nvim --headless "+Lazy! sync" +qa

info "Installing treesitter parsers..."
nvim --headless "+TSInstall all" +qa

info "Done! Open nvim to start using your config."