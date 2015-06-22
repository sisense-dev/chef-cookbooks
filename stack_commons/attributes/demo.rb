
# Encoding: utf-8
#
# Cookbook Name:: stack_commons
#
# Copyright 2014, Rackspace, Inc.
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

default['stack_commons']['demo']['enabled'] = false
default['stack_commons']['webserver'] = 'apache'

site1 = 'example.com'
site2 = 'test.com'
port1 = '80'
port2 = '8080'

# just need to define the sites so they can be itterated over by things like mysql

# apache site1
default['stack_commons']['demo']['apache']['sites'][port1][site1]['foo'] = 'bar'
default['stack_commons']['demo']['apache']['sites'][port2][site1]['foo'] = 'bar'

# apache site2
default['stack_commons']['demo']['apache']['sites'][port1][site2]['foo'] = 'bar'
default['stack_commons']['demo']['apache']['sites'][port2][site2]['foo'] = 'bar'
