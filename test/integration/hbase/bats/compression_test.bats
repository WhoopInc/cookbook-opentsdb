#!/usr/bin/env bash

@test "lzo compression" {
  hbase org.apache.hadoop.hbase.util.CompressionTest file:///tmp/testfile lzo
}

@test "gzip compression" {
  hbase org.apache.hadoop.hbase.util.CompressionTest file:///tmp/testfile gz
}

@test "snappy compression" {
  hbase org.apache.hadoop.hbase.util.CompressionTest file:///tmp/testfile snappy
}
