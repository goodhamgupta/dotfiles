export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/ 
alias tn="TERM=screen-256color-bce tmux new -s"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"

# function Extract for common file formats

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>" echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

IFS=$SAVEIFS

# Color schemes for terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# ZSH bindings for git.

alias g="git"
alias gst="git status"
alias gb="git branch"
alias ga="git add"
alias gau="git add -u"
alias gaa="git add --all"
alias gapa="git add --patch"
alias gc="git commit -v"
alias gc!="git commit -v --amend"
alias gca="git commit -v -a"
alias gca!="git commit -v -a --amend"
alias gcan!="git commit -v -a --no-edit --amend"
alias gcans!="git commit -v -a -s --no-edit --amend"
alias ggpush="git push -u origin $__git_ps1"
alias ggpull="git pull origin $__git_ps1"
alias gcb="git checkout -b"
alias gcl="git clone --recursive"
alias gcm="git checkout master"
alias gco="git checkout"
alias gd="git diff"
alias gdca="git diff --cached"
alias glg="git log --stat --max-count = 10"
alias glgg="git log --graph --max-count = 10"
alias glgga="git log --graph --decorate --all"
alias glo="git log --oneline --decorate --color"
alias glog="git log --oneline --decorate --color --graph"
alias glp="_git_log_prettily (git log --pretty=$1)"
alias gm="git merge"
alias gma="git merge --abort"
alias gp="git push"
alias gwip="git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--""
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'

# Set oranization specific git config
function set_git_org {
    git config user.name 'Shubham Gupta'
    git config user.email 'shubham.gupta@temus.com'
}

function install_pip {
    curl https://bootstrap.pypa.io/get-pip.py | python3
}
function add_resolution {
    sudo cvt 1920 1080 60
    sudo xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
    sudo xrandr --addmode DP-1-3 1920x1080_60.00
}
function connect_airpods {
    bluetoothctl connect 88:64:40:B8:89:75
}
function disconnect_airpods {
    bluetoothctl disconnect 88:64:40:B8:89:75
}
function create_env {
    python -m venv .env
    source .env/bin/activate
    pip3 install --upgrade pip
}
function set_brightness {
    xrandr --output HDMI-1 --brightness $1
}
function start_recording {
    ffmpeg -video_size 1920x1080 -framerate 128 -f x11grab -i :0.0+0,0 -c:v libx264rgb -crf 0 -preset ultrafast $1
}

function cvpn {
    nmcli con up id $1
}
function dvpn {
    name=$(eval nmcli con show --active | egrep vpn | awk '{print $1}')
    nmcli con down id $name
}
export PATH="~/.local/bin/:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"
export PATH="$PATH:~/julia-1.5.2/bin"
export PYTHONPATH="${PYTHONPATH}:~/.local/bin/"
export TASKDDATA="~/taskd/"
export PROMPT_DIRTRIM=2
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias open='xdg-open'

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh
