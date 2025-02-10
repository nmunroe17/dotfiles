################################################################################
#
# File:         ${HOME}/.bashrc
# Description:  Bash shell rc file
# Language:     bash
# File Author:  Keith Richling
#
################################################################################

   # Set the default umask
   umask 002

   # Only execute if interactive
   test "${-#*i}" != "$-" || return 0

   # Print a message
   echo "-> bashrc"

   # Do profile if asked.  Used when invoking a shell via remsh, since
   # this isnt a bona fide login
   test "${DO_PROFILE}" != "" && . ${HOME}/.bash_profile

   # Set information about the history files
   export histchars='!^'  # Get comments saved in history
   HISTDIR=${HOME}/.hist
   HISTFILE_BASH="${HISTDIR}/bash/hist_xxxxxx"
   export CBHISTFILE="${HISTDIR}/cb/hist_xxxxxx"
   export IEDHISTFILE="${HISTDIR}/ied/hist_xxxxxx"
   export HISTFILE="${HISTFILE_BASH}"
   export HISTSIZE=100000
   export HISTFILESIZE=${HISTSIZE}
   shopt -s histappend

   # Create the needed history directories
   if ! test -d $(dirname ${CBHISTFILE}); then
       command -p mkdir -p $(dirname ${CBHISTFILE})
   fi
   if ! test -d $(dirname ${IEDHISTFILE}); then
       command -p mkdir -p $(dirname ${IEDHISTFILE})
   fi
   if ! test -d $(dirname ${HISTFILE}); then
       command -p mkdir -p $(dirname ${HISTFILE})
   fi

   # Set up options
   set -o monitor          # enable job control
   set -o vi               # vi command-line editing
   export VISUAL=vi
   export EDITOR=vi
   set -o ignoreeof        # do not let CNTL-D exit the shell
   shopt -s checkwinsize   # Reset LINES and COLUMNS after each command

   # Set the prompt
   PS1='$(whoami)@$(hostname):[$(pwd)]'

   # Uncomment the following line to share history in all windows.
#   PROMPT_COMMAND="history -a;history -c;history -r"

   # Load aliases
   if [ -f ${HOME}/.bash_aliases ]; then
      . ${HOME}/.bash_aliases
   fi

   # Set the default printer
#   export PRINTER=daylight
#   export LPDEST=daylight

    # Make less display colors and not clear the screen
   export LESS="-XR"

   # Load completion function
   if [ -r /tools/ictools/bash-completion/bash_completion_loader.sh ]; then
       . /tools/ictools/bash-completion/bash_completion_loader.sh
   elif [ -r /etc/profile.d/bash_completion.sh ]; then
      . /etc/profile.d/bash_completion.sh
   fi

   # Load functions
   if [[ -f ${HOME}/.bash_functions.personal ]]
   then
      . ${HOME}/.bash_functions.personal
   fi

   bind 'set show-all-if-ambiguous on'
   bind 'set page-completions off'

   bind '"\e[1;5D": backward-word'
   bind '"\e[1;5C": forward-word'

   # Base16 Shell
   BASE16_SHELL="$HOME/.config/base16-shell/"
   [ -n "$PS1" ] && \
       [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
           source "$BASE16_SHELL/profile_helper.sh"
   
   base16_dracula

   # Print a message
   echo "<- bashrc"
. "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
 
   export PATH=/tools/bin:$PATH

source ~/actenv

#source ~/liquidprompt/liquidprompt
#source ~/liquidprompt-powerline/powerline.theme
#lp_theme powerline
