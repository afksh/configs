# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/Users/faiz/Library/Python/3.8/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="/Users/faiz/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

######################################################
#################### USER ZSHRC ######################
######################################################

# Aliases

alias l="exa --long --all --git --header --color-scale --sort modified --time-style iso --extended --time accessed --group --group-directories-first --links"
alias pods="arch -x86_64 pod install"
alias z="vi ~/.zshrc"

# Environment Variables
export APACHE_SITE_DOCS=/Library/WebServer
export APACHE_SERVER_CONFIG=/private/etc/apache2
export INTERVIEW_PREP=~/Developer/Career
export CONFIGS=~/Developer/configs

# Functions
cheat() {
    curl cheat.sh/$1
}

f () {
    if [ "$#" -ne 0 ]
    then
        line=1
        if [  "$#" -eq 2 ]
        then
            line=$2
            if [ $line -lt 1 ]
            then
                line=1
            fi
        fi
        paths=(`ag -i -g $1`)
        len=${#paths[@]}
        if [ $len -eq 0 ]
        then
            echo "No results found."
            return 1
        elif [ $len -eq 1 ]
        then
            vi +$line ${paths[0]}
        else
            echo "Files found:"
            echo
            for ((i=0;i<$len;i++))
            do
                echo "$((i + 1)): ${paths[$i]}"
            done
            echo
            choice=-1
            while [[ ! $choice || $choice = *[^0-9]* ]]; do
                echo "Which file would you like to edit?"
                if [ $len -lt 10 ]
                then
                    read -s -n 1 choice
                else
                    read choice
                fi
            done
            vi +$line ${paths[$((choice - 1))]}
        fi
    else
        echo "Please provide a search string or regex to recursively search for and open files in vim."
    fi
}

# Environment Setup
eval $(thefuck --alias)
