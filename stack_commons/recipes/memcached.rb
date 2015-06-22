# Encoding: utf-8
#
# Cookbook Name:: stack_commons
# Recipe:: memcached
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
include_recipe 'chef-sugar'
include_recipe 'apt' if platform_family?('debian')
include_recipe 'memcached'

# iptables
search_add_iptables_rules("tags:#{node['stack_commons']['stackname'].gsub('stack', '')}_app_node AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m tcp -p tcp --dport #{node['memcached']['port']} -j ACCEPT",
                          9999,
                          'Open port for memcached from app')

search_add_iptables_rules("tags:#{node['stack_commons']['stackname'].gsub('stack', '')}_app_node AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m udp -p udp --dport #{node['memcached']['port']} -j ACCEPT",
                          9999,
                          'Open port for memcached from app')

node.set['platformstack']['cloud_monitoring']['plugins']['memcached']['disabled'] = false
