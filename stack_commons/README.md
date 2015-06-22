# stack\_commons
## Supported Platforms
- CentOS 6.5
- Ubuntu 12.04
- Ubuntu 14.04

## Requirements
### Cookbooks
- `apache2`, `>= 3.0.0`
- `apt`
- `build-essential`
- `chef-sugar`
- `database`, `>= 2.3.1`
- `java`
- `memcached`
- `mongodb`
- `mysql`, `~> 5.0`
- `mysql-multi`
- `newrelic`
- `newrelic_meetme_plugin`
- `newrelic_plugins`
- `nginx`
- `openssl`
- `percona-multi`
- `pg-multi`
- `php`
- `platformstack`
- `python`
- `rabbitmq`
- `rackspace_gluster`
- `redis-multi`
- `uwsgi`
- `varnish`
- `yum`
- `yum-ius`
- `yum-epel`

## Recipes
### default
- what it does
  - nothing

### format\_disk
- what it does
  - sets up `node['disk']['name']` with the filesystem specified in `node['disk']['fs']`

### gluster
- what it does
  - sets up glusterfs based on the `node['rackspace_gluster']['config']['server']['glusters']` attribute
    - this may involve some manual setup, it is glusterfs afterall

### percona\_master
- what it does
  - sets up a percona master server node.

### percona\_slave
- what it does
  - sets up a percona slave server node.

### memcache
- what it does
  - sets up memcache
  - sets up the memcache cloud monitoring plugin if enabled

### mongodb\_standalone
- what it does
  - sets up mongodb from the 10gen repo

### mysql\_add\_drive
- what it does
  - calls `stack_commons::format_disk` to format a disk
  - creates the mysql user and manages the /var/lib/mysql mountpoint

### mysql\_base
- what it does
  - sets a random root mysql password if the default password would normally be set
  - sets up mysql
  - sets up a holland user if `node['holland']['enabled']`
  - sets up a monitoring mysql user and monitor if `node['platformstack']['cloud_monitoring']['enabled']`
  - allow app nodes in the environment to attempt to connect
  - auto-generates mysql databases and assiciated users/passwords for sites installed (can be disabled)
  - installs specific databases (will autogenerate the user and password if needed still)
- toggles
  - `node[stackname]['db-autocreate']['enabled']` controls database autocreation at a global level
  - if the site has the `db_autocreate` attribute, it will control database autocreation for that site
- info
  - auto-generated databases are based on site name and port number the site is on, same for username

### mysql\_holland
-  what it does
  -  installs holland
  -  will set up a backup job based on if you are running as a slave or not

### mysql\_master
- what it does
  - sets up mysql master (runs the mysql_base recipe as well)
  - will allow slaves to connect (via iptables)

### mysql\_slave
- what it does
  - sets up the mysql slave (runs the mysql_base recipe as well)
  - allows the master to connect (via iptables)

### newrelic
- what it does
  - sets up newrelic client
  - sets up the application agent as defined in `node['stack_commons']['application_monitoring'][app_type_goes_here]['enabled']`
  - sets up the following plugins (as needed)
    - memcache
    - rabbit
    - nginx
  - toggles
    - `node['stack_commons']['application_monitoring']['php']['enabled']` php application agent install
    - `node['stack_commons']['application_monitoring']['python']['enabled']` python application agent install
    - `node['stack_commons']['application_monitoring']['java']['enabled']` java application agent install

### nginx
- what it does
  - nothing

### postgresql\_base
- what it does
  - sets up a basic postgresql server and the associated monitoring checks (if enabled)
- toggles
  - `node['platformstack']['cloud_monitoring']['enabled']` controls the monitoring checks

### postgresql\_master
- what it does
  - sets up postgresql as a master
  - allows postgresql slaves to connect (via iptables)

### postgresql\_slave
- what it does
  - sets up postgresql as a slave
  - allows the postgresql master to connect (via iptables)

### rabbitmq
- what it does
  - allows nodes tagged as `"#{stackname.gsub('stack', '')}_app_node"` to connect (via iptables)
  - disables guest user
  - sets up the cloud monitoring plugin
  - sets up a monitoring user for rabbit (with password)
  - sets up rabbitmq vhost/user/password combinations for each vhost and port combination

### redis\_base
- what it does
  - sets up redis (basic)
  - allows nodes tagged as `"#{stackname.gsub('stack', '')}_app_node` to connect (via iptables)
  - allows nodes tagged as `"#{stackname}-redis"` to connect (via iptables)

### redis\_master
- what it does
  - sets up redis in a master capacity

### redis\_sentinel
- what it does
  - sets up redis sentinel
  - allows nodes tagged as `"#{stackname.gsub('stack', '')}_app_node"` to connect (via iptables)
  - allows nodes tagged as `"#{stackname}-redis_sentinel"` to connect (via iptables)
  - allows nodes tagged as `"#{stackname}-redis"` to connect (via iptables)

### redis\_single
- what it does
  - sets up redis in a standalone capacity

### redis\_slave
- what it does
  - sets up redis in a slave capacity

### varnish
- what it does
  - allows clients to connect to the varnish port (via iptables)
  - enables the cloud monitoring plugin for varnish
  - sets the default backend port to the first useful port it can find
  - sets up varnish if for multi backend load ballancing per vhost/port combination
- toggles
  - `node['varnish']['multi']` controls if varnish is simple or complex (multi backend or not)
    - it is also controled by if any backend nodes are found


## Data_Bags

No Data_Bag configured for this cookbook

## Attributes

### default

- `default['stack_commons']['stackname'] = 'stack_commons'`
  - this is the namespace we set stack specific attributes within

##### the following are namespaced attribues taken from the name above
- `default['stack_commons']['mysql']['databases'] = {}`
  - contains a hash of database names to set up with users / passwords as the content
- `default['stack_commons']['rabbitmq']['passwords'] = {}`
  - contains a hash of users with passwords as the value
- `default['stack_commons']['db-autocreate']['enabled'] = true`
  - controls database autocreation for each site / port combination globally
- `default['stack_commons']['varnish']['multi'] = true`
  - controls whether or not varnish is set up for multiple sites
- `default['stack_commons']['application_monitoring']['php']['enabled'] = false`
  - controls application monitoring via php
- `default['stack_commons']['application_monitoring']['python']['enabled'] = false`
  - controls application monitoring via python
- `default['stack_commons']['application_monitoring']['java']['enabled'] = false`
  - controls application monitoring via java

##### and the rest
- `default['disk']['name'] = '/dev/xvde1'`
  - used for disk auto format, lists the device to format
- `default['disk']['fs'] = 'ext4'`
  - the filesytem you wish to use to format, you need to have mkfs.FS_TYPE installed
- `default['holland']['enabled'] = false`
  - controls whether or not to use holland for backup of mysql
- `default['holland']['password'] = 'notagudpassword'`
  - default password that holland uses to access the database for backups
- `default['holland']['cron']['day'] = '*'`
  - how often we run the backup, every day by default
- `default['holland']['cron']['hour'] = '3'`
  - what time during the day to run the backup, 3AM local server time by default
- `default['holland']['cron']['minute'] = '12'`
  - what time within the hour that we run the backup, 12 minutes by default

### cloud_monitoring
- `default['stack_commons']['cloud_monitoring']['agent_mysql']['disabled'] = false`
  - controls rackspace cloud monitoring for mysql
- `default['stack_commons']['cloud_monitoring']['agent_mysql']['alarm'] = false`
  - controls if alerts get sent out
- `default['stack_commons']['cloud_monitoring']['agent_mysql']['period'] = 60`
  - how often we want to check
- `default['stack_commons']['cloud_monitoring']['agent_mysql']['timeout'] = 15`
  - how long we want to wait while sending checks
- `default['stack_commons']['cloud_monitoring']['agent_mysql']['user'] = 'raxmon-agent'`
  - mysql user the agent check will connect as
- `default['stack_commons']['cloud_monitoring']['agent_mysql']['password'] = nil`
  - mysql password the agent check will connect as
- `default['platformstack']['cloud_monitoring']['custom_monitors']['name'].push('mysql')`
  - actually sets up the mysql monitor
- `default['platformstack']['cloud_monitoring']['custom_monitors']['mysql']['source'] = 'monitoring-agent-mysql.yaml.erb'`
  - the template that the mysql monitor uses
- `default['platformstack']['cloud_monitoring']['custom_monitors']['mysql']['cookbook'] = 'stack_commons'`
  - the cookbook that the template for mysql is sourced from

##### also contains a list of attributes to control rackspace cloud monitoring, for more information see https://github.com/rackspace-cookbooks/platformstack

### demo

contains attributes that used in a demo site, useful as an example of what to set to deploy a site

### gluster

- `default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1'] = {}`
  - initializing the datastructure for controling glusterfs along with setting the cluster's name to 'Gluster Cluster 1'
- `default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['volume'] = 'vol0'`
  - sets the volume to be used with 'Gluster Cluster 1'

### logstash

contains a list of attributes a for setting up logging to elkstack

for more information see https://github.com/rackspace-cookbooks/elkstack/

### newrelic
- `default['stack_commons']['newrelic']['mysql']['user'] = 'newrelic-agent'`
  - the user that newrelic uses to monintor mysql metrics
- `default['stack_commons']['newrelic']['mysql']['password'] = nil`
  - the password that newrelic uses (nil means it's automaticly generated)

## Usage

### useful datastructures

- databases
```json
{
    "stack_commons": {
      "mysql": {
        "example_db": {
          "user": "exampleuser",
          "password": "do_not_use_this_password"
        }
      }
    }
}
```

### stack_commons

- MySQL DB Single Node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[platformstack::rackops_rolebook]",
      "recipe[stack_commons::mysql_base]"
    ]
}
```

- MySQL DB Master Node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[platformstack::rackops_rolebook]",
      "recipe[stack_commons::mysql_master]"
    ]
}
```

- MySQL DB Slave Node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[platformstack::rackops_rolebook]",
      "recipe[stack_commons::mysql_slave]"
    ]
}
```


- PostgreSQL clustering

Ensure the following attributes are set within environment or wrapper cookbook

```ruby
node['postgresql']['version'] = '9.3'
node['postgresql']['password'] = 'postgresdefault'
node['pg-multi']['replication']['password'] = 'useagudpasswd'
node['pg-multi']['master_ip'] = '1.2.3.4'
node['pg-multi']['slave_ip'] = ['5.6.7.8']

# Depending on OS one of the following two must be set:
node['postgresql']['enable_pdgd_yum'] = true  # (Redhat Family)
node['postgresql']['enable_pdgd_apt'] = true  # (Debian Family)
```

- Master PostgreSQL node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[platformstack::rackops_rolebook]",
      "recipe[stack_commons::postgresql_master]"
    ]
}
```

- Slave PostgreSQL node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[platformstack::rackops_rolebook]",
      "recipe[stack_commons::postgresql_slave]"
    ]
}
```

## Other Notes
### New Relic Monitoring

To configure New Relic, make sure the `node['newrelic']['license']` attribute is set and include the `platformstack` cookbook in your run_list.  You can also run the `stack_commons::newrelic` recipe for some more advanced monitors.

### Monitoring

Monitoring is set up only when platformstack is present. See platformstack's [README.md](https://github.com/rackspace-cookbooks/platformstack#monitors) and [attribute file on monitors](https://github.com/rackspace-cookbooks/platformstack/blob/master/attributes/cloud_monitoring.rb#L101-L123).

### New Relic Plugins

Due to a resource name conflict between elasticsearch and newrelic_plugins cookbook we are using a fork rather than the upstream cookbook. You need to get this fork or add the following lines to your Berkshelf file :

    cookbook 'newrelic_plugins', git: 'git@github.com:rackspace-cookbooks/newrelic_plugins_chef.git'

More details : https://github.com/newrelic-platform/newrelic_plugins_chef/pull/29

# Contributing

https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md


# Authors
Authors:: Matthew Thode <matt.thode@rackspace.com>
