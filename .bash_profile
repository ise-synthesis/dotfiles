export LANG=ja_JP.UTF-8
# LANGUAGE は GNU gettext ぐらいでしか使わないらしい
# LANG より優先度高い
# この書き方で順番に試行するはず
export LANGUAGE=ja_JP:ja:en_US:en
export EDITOR=vim
export PAGER=less
#export TERM=xterm-256color

umask 022

unset MAILCHECK

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi

if [ -f "${HOME}/.bash_profile.local" ] ; then
  source "${HOME}/.bash_profile.local"
fi
