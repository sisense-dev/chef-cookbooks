# Encoding: utf-8

=begin
#<
Install Kibana.
#>
=end

group node['kibana']['group'] do
end

user node['kibana']['user'] do
  comment 'Kibana Server'
  gid node['kibana']['group']
  home node['kibana']['base_dir']
  shell '/bin/bash'
  system true
end

directory node['kibana']['base_dir'] do
  mode '0755'
  owner node['kibana']['user']
  group node['kibana']['group']
  recursive true
end

#include_recipe "kibana::kibana#{node['kibana']['version'][0]}"
# Encoding: utf-8

include_recipe 'chef-kibana::kibana4'

if node['kibana']['install_method'] == 'release'
  ark 'kibana' do
    url node['kibana']['url']
    version node['kibana']['kibana4_version']
    checksum node['kibana']['kibana4_checksum']
    path node['kibana']['base_dir']
    home_dir File.join(node['kibana']['base_dir'], 'current')
  end
  config_path = 'current/config/kibana.yml'
else
    Chef::Application.fatal!("Since Kibana version 4, install method can only be only 'release'")
end

# Apply config template
template File.join(node['kibana']['base_dir'], config_path) do
  cookbook node['kibana']['config']['cookbook']
  source   node['kibana']['config']['source']
  owner    node['kibana']['user']
  group    node['kibana']['group']
  mode     '0644'
  variables(
    bind:       node['kibana']['interface'],
    port:       node['kibana']['port'],
    es_host:    node['kibana']['elasticsearch']['hosts'].first,
    es_port:    node['kibana']['elasticsearch']['port'],
    index:      node['kibana']['index'],
    defaultapp: node['kibana']['defaultapp']
  )
  notifies :restart, 'service[kibana]'
end

# Install service
include_recipe 'chef-kibana::_service'

