# Encoding: utf-8
#
# Cookbook Name:: stack_commons
# Recipe:: percona_slave
#
# Copyright 2015, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'percona-multi::slave'

add_iptables_rule('INPUT', "-p tcp --dport #{node['percona']['port']} -s #{node['percona']['master']} -j ACCEPT", 9243, 'allow percona master to connect to slaves')
