# Encoding: utf-8
#
# Cookbook Name:: stack_commons
# Recipe:: gluster
#
# Copyright 2014, Rackspace Hosting
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

default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1'] = {}
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['volume'] = 'vol0'

# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['ip'] = '33.33.33.10'
# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['block_device'] = '/dev/sdb'
# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['mount_point'] = '/mnt/brick0'
# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['brick_dir'] = '/mnt/brick0/brick'

# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['ip'] = '33.33.33.11'
# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['block_device'] = '/dev/sdb'
# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['mount_point'] = '/mnt/brick0'
# default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['brick_dir'] = '/mnt/brick0/brick'
