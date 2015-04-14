#! /bin/bash
set -o verbose

# Let's do everything in the home directory.
cd ~

# Install some packages
packages=( \
	vim-gnome \
	python-dev \
	python3-dev \
	meld \
	build-essential \
	git \
	mercurial \
	curl \
	wget \
	zsh \
	cmake \
	python-pip \
	python3-pip \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
	g++ \
)

for package in "${packages[@]}"; do
	sudo apt-get install -y ${package}
done

sudo pip3 install ipython[notebook]

# Only want one version of virtualenv.
sudo pip install virtualenvwrapper

sudo pip install ipython

# set up vim
mkdir .vim
git clone https://github.com/gmarik/Vundle.vim.git .vim/bundle/Vundle.vim

cat <<EOT > .vimrc
" Trim trailing whitespace on save.
autocmd BufWritePre * :%s/\s\+\$//e

" Treat markdown files right.
au BufRead,BufNewFile *.md set filetype=markdown

" Vundle stuff
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" jedi-vim autocompletion for Python
Plugin 'davidhalter/jedi-vim'
" Python awesome glory
"Plugin 'klen/python-mode'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set tabstop=4       " Number of spaces that a <Tab> in the file counts for.

set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.

set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
                    " Spaces are used in indents with the '>' and '<' commands
                    " and when 'autoindent' is on. To insert a real tab when
                    " 'expandtab' is on, use CTRL-V <Tab>.

set smarttab        " When on, a <Tab> in front of a line inserts blanks
                    " according to 'shiftwidth'. 'tabstop' is used in other
                    " places. A <BS> will delete a 'shiftwidth' worth of space
                    " at the start of the line.

set nowrap
set showcmd         " Show (partial) command in status line.

set number          " Show line numbers.

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.

set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.

set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.

set ignorecase      " Ignore case in search patterns.

set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.

set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).

set textwidth=79    " Maximum width of text that is being inserted. A longer
                    " line will be broken after white space to get this width.

set formatoptions=c,q,r,t " This is a sequence of letters which describes how
                    " automatic formatting is to be done.
                    "
                    " letter    meaning when present in 'formatoptions'
                    " ------    ---------------------------------------
                    " c         Auto-wrap comments using textwidth, inserting
                    "           the current comment leader automatically.
                    " q         Allow formatting of comments with "gq".
                    " r         Automatically insert the current comment leader
                    "           after hitting <Enter> in Insert mode.
                    " t         Auto-wrap text using textwidth (does not apply
                    "           to comments)

" backspaces and cursor keys wrap too
set whichwrap+=b,s,[,]

" enable the use of a mouse
set mouse=a

inoremap jk <Esc>
filetype plugin indent on
syntax on
set ruler

set backspace=2 " Let backspace delete newlines (\n)

" make the cursor change in insert mode.
if has("autocmd")
   au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
   au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
   au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
endif
" Start with cursor in block mode.
:silent !gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block

EOT

cat <<EOT > .gitconfig

[alias]
	ci = commit
	st = status -u
	meld = difftool -y --dir-diff
[core]
	editor = vim
[user]
	name = Cody Piersall
	email = codypi@ou.edu
[diff]
	tool = meld
[difftool "meld"]
	cmd = meld \"\$LOCAL\" \"\$REMOTE\"
[push]
	default = simple
[color]
	ui = true
[credential]
	helper = cache --timeout=360000
EOT

cat <<EOT > .hgrc
[ui]
# Name data to appear in commits
username = Cody Piersall <codypi@ou.edu>
ssh = ssh -C

[alias]
hgrc = !\$EDITOR ~/.hgrc

[extensions]
extdiff =
convert =
purge =
color =
pager =

[extdiff]
cmd.meld =
cmd.vimdiff =

[pager]
pager = LESS='FRSXQ' less
attend = annotate, log, cat, diff
EOT

cat <<EOT > .bashrc
# virtual environment
export WORKON_HOME=\$HOME/.venvs
source /usr/local/bin/virtualenvwrapper.sh

set -o vi
EOT

cat <<EOT > .zshrc
# Path to your oh-my-zsh installation.
export ZSH=/home/pier3595/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than \$ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git mercurial python vi-mode vim virtualenvwrapper)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:\$MANPATH"

source \$ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n \$SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Make vim not take forever to enter command mode
export KEYTIMEOUT=1

# virtual environment
export WORKON_HOME=\$HOME/.venvs
source /usr/local/bin/virtualenvwrapper.sh

set -o vi

EOT
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

sudo apt-get update -y
sudo apt-get upgrade -y

echo Done provisioning.
echo ------------------
echo
sudo chsh -s /bin/zsh $USER
