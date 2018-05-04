all:

check: check-guess check-sub

manpages: doc/config.guess.1 doc/config.sub.1

doc/config.guess.1: config.guess
	help2man -N --include=doc/config.guess.x --output=$@ ./config.guess

doc/config.sub.1: config.sub
	help2man -N --name "validate and canonicalize a configuration triplet" --output=$@ ./config.sub

check-guess:
	cd testsuite && sh config-guess.sh && rm uname

check-sub:
	cd testsuite && sh config-sub.sh

shellcheck:
	shellcheck -e SC2006 -f gcc config.guess config.sub
