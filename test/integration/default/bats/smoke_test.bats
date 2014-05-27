#!/usr/bin/env bats

tsdb() {
	sudo sudo -u opentsdb tsdb "$@"
}

@test "metric creation" {
	tsdb mkmetric "sys.cpu.user"
}

@test "data insertion" {
	tsdb import "$BATS_TEST_DIRNAME/data.txt"
}

@test "data retrieval" {
	run tsdb query 2010/01/01 sum sys.cpu.user
	[[ "$status" -eq 0 ]]
	[[ "${lines[-3]}" = "sys.cpu.user 1356998400000 42 {host=web01, cpu=0}" ]]
	[[ "${lines[-2]}" = "sys.cpu.user 1356998500000 43 {host=web01, cpu=0}" ]]
	[[ "${lines[-1]}" = "sys.cpu.user 1356998600000 42 {host=web01, cpu=0}" ]]
}
