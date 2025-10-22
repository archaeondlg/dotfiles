# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
ZSH_THEME="arch"

# disabled, auto, reminder(just remind me to update when it's time)
zstyle ':omz:update' mode auto
# how often to auto-update (in days).
zstyle ':omz:update' frequency 30

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-syntax-highlighting zsh-autosuggestions sudo extract)

source $ZSH/oh-my-zsh.sh

# User configuration
# export LANG=en_US.UTF-8
export EDITOR='vim'
export TERM=xterm-256color

# bind keys
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line

# define aliases within the ZSH_CUSTOM folder.
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
