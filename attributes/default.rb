##
# Cloudera repositories
##

node.default['apt']['cloudera']['force_distro'] = 'precise'

##
# hbase-site.xml
##

# Configures hbase.rootdir. MUST be preceded with filesystem protocol.
node.default['hbase']['root_dir'] = 'file:///hbase/whoop'
