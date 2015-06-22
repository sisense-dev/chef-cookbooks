# Encoding: utf-8
#
# Cookbook Name:: stack_commons
# Recipe:: varnish
#
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

stackname = node['stack_commons']['stackname']

include_recipe 'chef-sugar'
if platform_family?('debian')
  include_recipe 'apt'
else
  include_recipe 'yum-epel'
end

# check if they exist, then set demo attributes if needed
# -- it seems bad to be touching webserver attributes here.
webserver = node.deep_fetch(stackname, 'webserver')
node.default[stackname][webserver]['sites'] = node.deep_fetch(stackname, 'demo', webserver, 'sites') if webserver && node.deep_fetch(stackname, 'demo', 'enabled')

add_iptables_rule('INPUT', "-p tcp --dport #{node['varnish']['listen_port']} -j ACCEPT", 9997, 'allow web browsers to connect')

# enable agent for cloud monitoring
node.set['platformstack']['cloud_monitoring']['plugins']['varnish']['disabled'] = false

# set the default port to send things on to something that might be useful
listen_ports = node.deep_fetch(webserver, 'listen_ports')
node.default['varnish']['backend_port'] = listen_ports.first if listen_ports && !listen_ports.empty?

# pull a list of backend hosts to populate the template
backend_hosts = {}
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  # build a list of nodes from the backend_nodes attribute if we aren't doing search
  backend_nodes = ({}).merge(node[stackname]['varnish']['backend_nodes'] || {})
else
  backend_nodes = search('node', "tags:#{stackname.gsub('stack', '')}_app_node AND chef_environment:#{node.chef_environment}")
  Chef::Log.warn('Search for varnish backend nodes returned no results, may be skipped...') if backend_nodes.nil? || backend_nodes.empty?
end

# convert backend_nodes into backend_hosts list
backend_nodes.each do |backend_node|
  backend_node[stackname][node[stackname]['webserver']]['sites'].each do |port, sites|
    sites.each do |site_name, site_opts|
      found_ip = best_ip_for(backend_node)
      Chef::Log.warn("Could not determine IP for varnish backend #{backend_node}, skipping it...") if found_ip.nil?
      next if found_ip.nil?
      backend_hosts.merge!(
        found_ip => { port => { site_name: site_name } }
      )
    end
  end
end

node.default[stackname]['varnish']['backends'] = backend_hosts

# only set if we have backends to populate (aka not on first run with an all in one node)
if backend_hosts.first.nil?
  # if our backends go away we needs this
  node.default['varnish']['vcl_cookbook'] = 'varnish'
  node.default['varnish']['vcl_source'] = 'default.vcl.erb'
else
  # let us set up a more complicated vcl config if needed
  node.default['varnish']['vcl_cookbook'] = 'stack_commons' if node[stackname]['varnish']['multi']
  node.default['varnish']['vcl_source'] = 'varnish-default-vcl.erb' if node[stackname]['varnish']['multi']
end
include_recipe 'varnish::default'
