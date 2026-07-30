# Put this on top of ~/.zshrc

# See https://wiki.archlinux.org/title/Zsh

# https://lgug2z.com/articles/sensible-wordchars-for-most-developers/
export WORDCHARS='*?[]~&;!#$%^(){}<>'

# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
export HISTORY_IGNORE="(l[sal]|l[sal] *|cd|cd ..|cd ../*|..|../*|rm *|mkdir *|touch *|open *|pwd|exit|bash|zsh|export *|z|z ..|z ../*|g co *|g me *|g br*|g df*|g sh*|g restore *|g revert *|g ass *|curl *|wcurl *|bat *|rg *|fd *|*go build *|*go run*|*go test*|go install *|docker run *|docker build *|docker push *|docker login *|docker logs *|xan *|xavi *|ffmpeg *|yt-dlp *|llama*)"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

# https://zsh.sourceforge.io/Doc/Release/Options.html
setopt AUTO_CD
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY_TIME

# https://stackoverflow.com/q/12382499
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/completion.zsh
# https://thevaluable.dev/zsh-completion-guide-examples/
# https://damn.engineer/2022/09/28/zsh-case-insensitive
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*'
zstyle ':completion:*' special-dirs true

autoload -Uz compinit
compinit
