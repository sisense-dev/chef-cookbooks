# Encoding: utf-8
#
# Cookbook Name:: stack_commons
# Recipe:: mysql_master
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

include_recipe 'stack_commons::mysql_base'
include_recipe 'mysql-multi::mysql_master'

node['mysql-multi']['slaves'].each do |slave|
  next if slave.nil?
  add_iptables_rule('INPUT', "-p tcp --dport #{node['mysql']['port']} -s #{slave} -j ACCEPT", 9243, 'allow slaves to connect to master')
end
