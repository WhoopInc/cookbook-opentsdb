## Notice: This repository is no longer maintained as of 3/26/2024

# cookbook-opentsdb

<a href="https://travis-ci.org/WhoopInc/cookbook-opentsdb">
  <img src="https://travis-ci.org/WhoopInc/cookbook-opentsdb.svg?branch=master"
  alt="Build Status">
</a>

Installs and configures OpenTSDB, the scalable time series database.

For more details on OpenTSDB, see:

> http://opentsdb.net

## Requirements

### Platforms

* Debian 6.0.8
* Ubuntu 10.04, 12.04

Pull requests for additional platforms welcomed!

## Recipes

All recipes install Java from the [java cookbook][java-cookbook]. By default,
OpenJDK v6 is installed on Squeeze and Lucid, and v7 on Precise. This can be
configured with the appropriate `node['java']` attributes.

Be sure to include `apt::default` from the [apt cookbook][apt-cookbook] in your
run list to ensure apt package caches are up-to-date.

### default

Includes `opentsdb::hbase` and `opentsdb::opentsdb`. Useful for configuring a
single server as a standalone HBase instance and OpenTSDB time-series daemon,
the recommended configuration until you can build a Hadoop cluster of at least
five nodes.

### hbase

Installs and configures HBase in standalone mode.

HBase is installed from [Cloudera's CDH4][cloudera-cdh4] apt repository, which
includes HBase v0.94.

### opentsdb

Installs OpenTSDB from an upstream-provided Debian package and configures server
as a time-series daemon.

## Attributes

### hbase

* **`node['hbase']['conf_dir']`**

  The subdirectory of `/etc/hbase/` in which to store custom configuration
  files. The Debian [`update-alternatives`][update-alternatives] command will be
  used to point at this directory instead of clobbering the default
  configuration.

  Defaults to `conf.chef`.

* **`node['hbase']['root_dir']`**

  Where HBase should store its data. See [`hbase.rootdir`][hbase-rootdir].

  Note that this cookbook only supports standalone mode, so only local file
  paths are supported. That is, you cannot specify a Hadoop path (`hdfs://`).

  Defaults to `/var/lib/hbase`.

* **`node['hbase']['lzo_compression']`**

  Whether to install [LZO compression support][lzo-compression] for Hadoop and
  HBase.

  Defaults to `true`.

* **`node['hbase']['nofile']`**

  The maximum number of files HBase can have open. See the HBase Reference's
  [`ulimit` and `nproc`][reference-ulimit] for advice.

  Defaults to `32_768`.

* **`node['hbase']['nproc']`**

  The maximum number of processes that can be created by HBase. See the HBase
  Reference's [`ulimit` and `nproc`][reference-ulimit] for advice.

  Defaults to `32_000`.

### opentsdb

* **`node['opentsdb']['package_url']`**

  The URL to the Debian package for the desired release. See upstream's [list of
  releases][opentsdb-releases].

  Defaults to the Debian package for 2.0.0.

* **`node['opentsdb']['package_checksum']`**

  The checksum of the downloaded package.

* **`node['opentsdb']['create_tables']`**

  Whether to create OpenTSDB's necessary HBase tables, if they haven't yet
  been created. Note that this requires HBase to be running on the same machine.

  Defaults to `true`.

* **`node['opentsdb']['compression']`**

  The compression algorithm used on OpenTSDB's HBase tables. This setting only
  has effect if `create_tables` is `true` and the tables have not yet been
  created. See the [OpenTSDB installation instructions][opentsdb-install] for
  details.

  Possible values are `none`, `lzo`, `gzip`, and `snappy`. Defaults to `lzo`.

#### Configuration

The `opentsdb.conf` config file is automatically generated from the
`node['opentsdb']['config']` hash. Each key-value will be output as a properly
formatted line in the config file.

Default values:

```ruby
node['opentsdb']['config']['tsd.network.port'] = 4242
node['opentsdb']['config']['tsd.http.cachedir'] = '/tmp/opentsdb'
node['opentsdb']['config']['tsd.http.request.enable_chunked'] = true
node['opentsdb']['config']['tsd.http.staticroot'] = '/usr/share/opentsdb/static'
```

See [Configuration][opentsdb-conf] in the OpenTSDB user guide for all possible
configuration values.

Note that arrays will be automatically converted to a comma-separated string.

## Testing

See [TESTING](TESTING.md).

[apt-cookbook]: https://github.com/opscode-cookbooks/apt
[cloudera-cdh4]: http://cloudera.com/content/cloudera-content/cloudera-docs/CDH4/latest/CDH4-Release-Notes/CDH4-Release-Notes.html
[hbase-rootdir]: http://hbase.apache.org/book/config.files.html#hbase.rootdir
[java-cookbook]: https://github.com/socrata-cookbooks/java
[lzo-compression]: http://hbase.apache.org/book/lzo.compression.html
[opentsdb-conf]: http://opentsdb.net/docs/build/html/user_guide/configuration.html
[opentsdb-install]: http://opentsdb.net/docs/build/html/installation.html#create-tables
[opentsdb-releases]: https://github.com/OpenTSDB/opentsdb/releases
[reference-ulimit]: http://hbase.apache.org/0.94/book.html#ulimit
[update-alternatives]: http://manpages.ubuntu.com/manpages/precise/man8/update-alternatives.8.html
