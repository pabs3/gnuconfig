all:

check:
	cd testsuite && (sh config-sub.sh; sh config-guess.sh) && rm uname
