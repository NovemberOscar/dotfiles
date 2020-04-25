BREW := /usr/local/bin/brew
HASKELL = $(HOME)/.ghcup/bin/ghcup
RUST := $(HOME))/.cargo/bin/rustup
POETRY := $(HOME)/.poetry/bin/poetry

.PHONY: all 
all: brew zsh git poetry rust


.PHONY: brew
brew: | $(BREW) ## Install brew if it isn't installed, then update brew 
	ln  -sfn $(CURDIR)/Brewfile $(HOME)/Brewfile
	brew tap homebrew/bundle
	brew bundle

$(BREW): ## Install brew if it's not installed already
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: zsh 
zsh: ## Install the zsh related dotfiles.
	@echo "Starting zsh Setup..."
	mkdir -p ~/.zfunc
	ln -sfn $(CURDIR)/zshrc $(HOME)/.zshrc
	@echo "Done! (zsh)\n"

.PHONY: git
git: ## Install git configs.
	ln -sfn $(CURDIR)/gitalias $(HOME)/.gitalias
	@cp $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@read -p "Enter your name: " git_name; \
		sed -i -e "s/{{GIT_NAME}}/$$git_name/g" $(HOME)/.gitconfig
	@read -p "Enter your e-mail: " git_email; \
		sed -i -e "s/{{GIT_EMAIL}}/$$git_email/g" $(HOME)/.gitconfig
	@read -p "Enter your GPG key ID: " git_sign_key; \
		sed -i -e "s/{{GIT_SIGN_KEY}}/$$git_sign_key/g" $(HOME)/.gitconfig

.PHONY: haskell
haskell: | $(HASKELL)
	ghcup install

$(HASKELL):
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

.PHONY: rust
rust: | $(RUST)
	rustup update
	rustup set profile complete
	rustup completions zsh > ~/.zfunc/_rustup
	rustup completions zsh cargo > ~/.zfunc/_cargo

$(RUST):
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

.PHONY: poetry
poetry: | $(POETRY)
	poetry self update
	mkdir -p $(ZSH)/plugins/poetry
	poetry completions zsh > $(ZSH)/plugins/poetry/_poetry

$(POETRY):
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
