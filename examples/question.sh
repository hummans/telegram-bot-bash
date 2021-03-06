#!/bin/bash
########################################################################
#
# File: question.sh
#
# Usage: runproc example/question.sh - or run in terminal
#
# Description: example for an interactive chat, see mycommands.sh.dist
#
# This file is public domain in the USA and all free countries.
# Elsewhere, consider it to be WTFPLv2. (wtfpl.net/txt/copying)
#
#### $$VERSION$$ v1.40-0-gf9dab50
########################################################################

######
# parameters
# $1 $2 args as given to starct_proc chat script arg1 arg2
# $3 path to named pipe

INPUT="${3:-/dev/stdin}"

# adjust your language setting here
# https://github.com/topkecleon/telegram-bot-bash#setting-up-your-environment
export 'LC_ALL=C.UTF-8'
export 'LANG=C.UTF-8'
export 'LANGUAGE=C.UTF-8'

unset IFS
# set -f # if you are paranoid use set -f to disable globbing

# simple yes/no question, defaults to no
printf "Hi, hello there\nWould you like some tea (y/n)?\n"
read -r answer <"${INPUT}"
if [[ ${answer,,} == "y"* ]]; then
	printf "OK then, here you go: http://www.rivertea.com/blog/wp-content/uploads/2013/12/Green-Tea.jpg\n"
else
	printf "OK then, no tea ...\n"
fi

# question with Keyboard, repeating until correct answer given
until [ "${SUCCESS}" = "y" ] ;do
	printf 'Do you like Music? mykeyboardstartshere "Yass!" , "No"\n'
	read -r answer <"${INPUT}"
	case ${answer,,} in
		'') printf "empty answer! Try again\n";; 
		'yass'*) printf "Goody! mykeyboardendshere\n";SUCCESS=y;;
		'no'*) printf "Well that's weird. mykeyboardendshere\n";SUCCESS=y;;
		*) SUCCESS=n;;
	esac
done
printf "OK, Done!\n"

