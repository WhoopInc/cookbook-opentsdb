#!/usr/bin/env bats

@test "smoke test" {
  hbase org.jruby.Main "${BATS_TEST_DIRNAME}/smoke_test.rb"
}
