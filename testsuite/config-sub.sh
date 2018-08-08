#!/bin/bash
#
# Copyright 2004, 2005, 2009, 2014, 2018 Free Software Foundation,
# Inc.
# Contributed by Ben Elliston <bje@gnu.org>.
#
# This test reads pairs from config-sub.data: an alias and its
# canonical triplet.  config.sub is invoked and the test checks that
# the alias expands to the expected canonical triplet.

set -eu
shopt -s lastpipe
verbose=false

run_config_sub()
{
	local -i rc=0
	numtests=0
	name="checks"
	while read -r alias canonical ; do
		output=$(sh -eu ../config.sub "$alias")
		if test "$output" != "$canonical" ; then
			echo "FAIL: $alias -> $output, but expected $canonical"
			rc=1
		else
			$verbose && echo "PASS: $alias -> $canonical"
		fi
		numtests+=1
	done < config-sub.data
	return $rc
}

run_config_sub_idempotent()
{
	local -i rc=0
	numtests=0
	name="idempotency checks"
	sed -r 's/\t+/\t/g' < config-sub.data | cut -f 2 | uniq | while read -r canonical ; do
		output=$(sh -eu ../config.sub "$canonical")
		if test "$output" != "$canonical" ; then
			echo "FAIL: $canonical -> $output, but $canonical should map to itself"
			rc=1
		else
			$verbose && echo "PASS: $canonical -> $canonical"
		fi
		numtests+=1
	done
	return $rc
}

declare -i rc=0 numtests
declare name

for testsuite in run_config_sub run_config_sub_idempotent ; do
	if $testsuite; then
		$verbose || echo "PASS: config.sub $name ($numtests tests)"
	else
		rc=1
	fi
done

exit $rc
