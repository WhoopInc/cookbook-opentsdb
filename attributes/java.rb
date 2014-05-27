if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 12.04
  node.default['java']['jdk_version'] = '7'
else
  node.default['java']['jdk_version'] = '6'
end
