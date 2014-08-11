node.default['opentsdb']['package_url'] = 'https://github.com/OpenTSDB/opentsdb/releases/download/v2.0.0/opentsdb-2.0.0_all.deb'
node.default['opentsdb']['package_checksum'] = 'a0fa1368f49f42a70a60d26729c88a74410f2e2a4fe89fc7b41ba051b690e0e9'

node.default['opentsdb']['create_tables'] = true
node.default['opentsdb']['compression'] = 'lzo'

node.default['opentsdb']['config']['tsd.network.port'] = 4242
node.default['opentsdb']['config']['tsd.http.cachedir'] = '/tmp/opentsdb'
node.default['opentsdb']['config']['tsd.http.request.enable_chunked'] = true
node.default['opentsdb']['config']['tsd.http.staticroot'] = '/usr/share/opentsdb/static'

node.default['opentsdb']['create_tables_script'] = "#{node['hbase']['utils_dir']}/bin/TSDBTruncate"
