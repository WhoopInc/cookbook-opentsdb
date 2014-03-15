distro = node['apt']['cloudera']['force_distro'] || node['lsb']['codename']

apt_repository 'cloudera_cdh' do
  uri          "http://archive.cloudera.com/cdh4/ubuntu/#{distro}/amd64/cdh"
  distribution "#{distro}-cdh4"
  components   ['contrib']
  key          "http://archive.cloudera.com/cdh4/ubuntu/#{distro}/amd64/cdh/archive.key"
  arch         'amd64'
  deb_src      true
  action       :add
end

apt_repository 'cloudera_gplextras' do
  uri          "http://archive.cloudera.com/gplextras/ubuntu/#{distro}/amd64/gplextras/"
  distribution "#{node['lsb']['codename']}-gplextras4"
  components   ['contrib']
  key          "http://archive.cloudera.com/gplextras/ubuntu/#{distro}/amd64/gplextras/archive.key"
  arch         'amd64'
  deb_src      true
  action       :add
end
