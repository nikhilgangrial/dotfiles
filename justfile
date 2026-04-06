DOTFILES_DIR := "./dotfiles"
CONFIG_DIR  := "$HOME/.config"

set shell := ["bash", "-lc"]

install:
    set -euo pipefail; \
    if command -v brew >/dev/null 2>&1; then \
      echo "Detected Homebrew; installing via brew..."; \
      brew update; \
      brew install neovim wezterm tmux starship lazygit zoxide lsd btop bat || true; \
      brew install --cask wezterm || true; \
      brew install --cask font-bitstream-vera-sans-mono-nerd-font || true; \
    \
    elif command -v paru >/dev/null 2>&1; then \
      echo "Detected paru; installing via paru..."; \
      paru -Syu --noconfirm neovim-git wezterm-git tmux starship lazygit zoxide lsd btop bat || true; \
      paru -S --noconfirm wl-clipboard xclip || true; \
      paru --noconfirm ttf-bitstream-vera-mono-nerd || true; \
    \
    elif command -v yay >/dev/null 2>&1; then \
      echo "Detected yay; installing via yay..."; \
      yay -Syu --noconfirm neovim-git wezterm-git tmux starship lazygit zoxide lsd btop bat || true; \
      yay -S --noconfirm wl-clipboard xclip || true; \
      yay --noconfirm ttf-bitstream-vera-mono-nerd || true; \
    \
    else \
      echo "No supported package manager found (brew or yay/paru required). Aborting." >&2; \
      exit 1; \
    fi

setup-config NAME:
    set -euo pipefail; \
    src="{{DOTFILES_DIR}}/{{NAME}}"; \
    dest="{{CONFIG_DIR}}/{{NAME}}"; \
    if [ -L "${dest}" ]; then \
      printf "Skipped: %s is already a symlink\n" "${dest}"; \
    else \
      if [ -e "${dest}" ]; then \
        rm -rf -- "${dest}.backup"; \
        mv -- "${dest}" "${dest}.backup"; \
        printf "Moved: %s -> %s\n" "${dest}" "${dest}.backup"; \
      else \
        printf "No existing config at %s; skipping move\n" "${dest}"; \
      fi; \
      mkdir -p -- "$(dirname "${dest}")"; \
      ln -sfn -- "${src}" "${dest}"; \
      printf "Linked: %s -> %s\n" "${dest}" "${src}"; \
    fi

setup-tmux:
    set -euo pipefail; \
    just setup-config tmux; \
    if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then \
      git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"; \
      printf "Cloned TPM to %s/.tmux/plugins/tpm\n" "${HOME}"; \
    else \
      printf "TPM already present at %s/.tmux/plugins/tpm\n" "${HOME}"; \
    fi; \
    if [ -x "${HOME}/.tmux/plugins/tpm/bin/install_plugins" ]; then \
      "${HOME}/.tmux/plugins/tpm/bin/install_plugins" || true; \
    else \
      printf "TPM install script not executable or missing; skipping plugin install\n"; \
    fi

setup-starship:
    just setup-config starship.toml

setup-fish:
    just setup-config fish

setup-wezterm:
    just setup-config wezterm

setup-mise:
    just setup-config mise

setup-nvim:
    just setup-config nvim

# just install; \
setup-all:
    just setup-starship; \
    just setup-fish; \
    just setup-wezterm; \
    just setup-mise; \
    just setup-nvim; \
    just setup-tmux
