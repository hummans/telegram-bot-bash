#!/usr/bin/env bash
#===============================================================================
#
#          FILE: d-process_message-test.sh
# 
#         USAGE: must run only from dev/all-tests.sh
#
#   DESCRIPTION: test receiving messages
# 
#	LICENSE: WTFPLv2 http://www.wtfpl.net/txt/copying/
#        AUTHOR: KayM (gnadelwartz), kay@rrr.de
#
#### $$VERSION$$ v1.40-0-gf9dab50
#===============================================================================

# include common functions and definitions
# shellcheck source=test/ALL-tests.inc.sh
source "./ALL-tests.inc.sh"

set -e

# source bashbot.sh functionw
cd "${TESTDIR}" || exit 1
# shellcheck source=./bashbot.sh
source "${TESTDIR}/bashbot.sh" source
# shellcheck source=./bashbot.sh
source "${TESTDIR}/commands.sh" source 

# overwrite get_file for test
get_file() {
	printf "%s\n" "$1"
}

# get telegram input from file
export UPDATE
declare -Ax UPD

# run process_message --------------
ARRAYS="USER CHAT REPLYTO FORWARD URLS CONTACT CAPTION LOCATION MESSAGE VENUE SERVICE NEWMEMBER LEFTMEMBER PINNED"

printf "Check process_message regular message...\n"

UPDATE="$(< "${INPUTFILE}")"
Json2Array 'UPD' <"${INPUTFILE}"
set -x
{ pre_process_message "0"; process_message "0";  set +x; } >>"${LOGFILE}" 2>&1;
USER[ID]="123456789"; CHAT[ID]="123456789"

# output processed input
# shellcheck disable=SC2086
print_array ${ARRAYS}  >"${OUTPUTFILE}"
compare_sorted "${REFFILE}" "${OUTPUTFILE}" || exit 1

# run process_message ------------
printf "Check process_message service message...\n"

UPDATE="$(cat "${INPUTFILE2}")"
Json2Array 'UPD' <"${INPUTFILE2}"
set -x
{ pre_process_message "0"; process_message "0";  set +x; } >>"${LOGFILE}" 2>&1;
USER[ID]="123456789"; CHAT[ID]="123456789"

# output processed input
# shellcheck disable=SC2086
print_array ${ARRAYS}  >"${OUTPUTFILE}"
compare_sorted "${REFFILE2}" "${OUTPUTFILE}" || exit 1


printf "%s\n" "${SUCCESS}"

cd "${DIRME}" || exit 1
