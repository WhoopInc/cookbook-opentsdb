node.default['hbase']['conf_dir'] = 'conf.chef'
node.default['hbase']['root_dir'] = '/var/lib/hbase'

node.default['hbase']['lzo_compression'] = true

node.default['hbase']['nofile'] = 32_768
node.default['hbase']['nproc'] = 32_000
