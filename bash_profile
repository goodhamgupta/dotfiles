source ~/.bashrc
export PATH=/usr/local/openssl/bin:$PATH
export MANPATH=/usr/local/openssl/share/man:$MANPATH
export PATH=~/bin:$PATH
export PATH=/usr/local/Cellar/elasticsearch/5.1.1/bin:$PATH
export PATH=/usr/local/opt/mysql@5.6/bin:$PATH
export PATH="/Users/shubham/.local/lib/aws/bin/:$PATH"

export PATH="/Users/shubham/bin/:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

alias kcprod="AWS_PROFILE=production KUBECONFIG=~/.kube/config.prod kubectl"
alias hlprod="AWS_PROFILE=production KUBECONFIG=~/.kube/config.prod helm"
alias tn="TERM=screen-256color-bce tmux new -s"
alias ta="tmux a -t"
#!/bin/bash
# function Extract for common file formats

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
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
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
# export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$"

# ZSH bindings for git.

alias g="git"
alias ga="git add"
alias gst="git status"
alias gau="git add -u"
alias gaa="git add --all"
alias gapa="git add --patch"
alias gb="git branch | grep \* | cut -d ' ' -f2"
alias gc="git commit -v"
alias gc!="git commit -v --amend"
alias gca="git commit -v -a"
alias gca!="git commit -v -a --amend"
alias gcan!="git commit -v -a --no-edit --amend"
alias gcans!="git commit -v -a -s --no-edit --amend"
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
alias ggpush="git push -u origin $(git_current_branch)"

# Brew bash autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi
