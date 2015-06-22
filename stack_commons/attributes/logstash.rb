## Logstash attributes
## These don't have any impact unless the agent recipe or logstash recipe from
## ELK stack actually runs. And even when it does, the plugin doesn't care about
## paths that don't exist, so these are harmless to deploy everywhere for
## logstash.

# Ensure it's an empty array if no one else has set it
default_unless['elkstack']['config']['custom_logstash']['name'] = []

# Apache
default['elkstack']['config']['custom_logstash']['name'].push('apache')
default['elkstack']['config']['custom_logstash']['apache']['name'] = 'input_apache'
default['elkstack']['config']['custom_logstash']['apache']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['apache']['source'] = 'logstash/input_apache.conf.erb'
apache_log_dir = node['apache'] && node['apache']['log_dir']
default['elkstack']['config']['custom_logstash']['apache']['variables'] = { path: "#{apache_log_dir}/**log" }

# Gluster
default['elkstack']['config']['custom_logstash']['name'].push('gluster')
default['elkstack']['config']['custom_logstash']['gluster']['name'] = 'input_gluster'
default['elkstack']['config']['custom_logstash']['gluster']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['gluster']['source'] = 'logstash/input_gluster.conf.erb'
default['elkstack']['config']['custom_logstash']['gluster']['variables'] = {}

# Memcached
default['elkstack']['config']['custom_logstash']['name'].push('memcached')
default['elkstack']['config']['custom_logstash']['memcached']['name'] = 'input_memcached'
default['elkstack']['config']['custom_logstash']['memcached']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['memcached']['source'] = 'logstash/input_memcached.conf.erb'
default['elkstack']['config']['custom_logstash']['memcached']['variables'] = { path: '/var/log/*memcache*log' }

# MongoDB
default['elkstack']['config']['custom_logstash']['name'].push('mongodb')
default['elkstack']['config']['custom_logstash']['mongodb']['name'] = 'input_mongodb'
default['elkstack']['config']['custom_logstash']['mongodb']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['mongodb']['source'] = 'logstash/input_mongodb.conf.erb'
default['elkstack']['config']['custom_logstash']['mongodb']['variables'] = { path: '/var/log/mongodb/**' }

# MySQL
default['elkstack']['config']['custom_logstash']['name'].push('mysql')
default['elkstack']['config']['custom_logstash']['mysql']['name'] = 'input_mysql'
default['elkstack']['config']['custom_logstash']['mysql']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['mysql']['source'] = 'logstash/input_mysql.conf.erb'
default['elkstack']['config']['custom_logstash']['mysql']['variables'] = { path: '/var/log/mysql**' }

# Nginx
default['elkstack']['config']['custom_logstash']['name'].push('nginx')
default['elkstack']['config']['custom_logstash']['nginx']['name'] = 'input_nginx'
default['elkstack']['config']['custom_logstash']['nginx']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['nginx']['source'] = 'logstash/input_nginx.conf.erb'
nginx_log_dir = node['nginx'] && node['nginx']['log_dir']
default['elkstack']['config']['custom_logstash']['nginx']['variables'] = { path: "#{nginx_log_dir}/**log" }

# PostgreSQL
default['elkstack']['config']['custom_logstash']['name'].push('postgresql')
default['elkstack']['config']['custom_logstash']['postgresql']['name'] = 'input_postgresql'
default['elkstack']['config']['custom_logstash']['postgresql']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['postgresql']['source'] = 'logstash/input_postgresql.conf.erb'
# have to do the chain of && in case postgres isn't included in runlist, these may not exist
postgresql_log_dir = node['postgresql'] && node['postgresql']['config'] && node['postgresql']['config']['log_directory']
postgresql_data_dir = node['postgresql'] && node['postgresql']['config'] && node['postgresql']['config']['data_directory']
default['elkstack']['config']['custom_logstash']['postgresql']['variables'] = { path: "#{postgresql_data_dir}/#{postgresql_log_dir}/**log" }

# ensure it's an array before we start shoving data into it
default_unless['elkstack']['config']['custom_logstash']['name'] = []

# RabbitMQ
default['elkstack']['config']['custom_logstash']['name'].push('rabbitmq')
default['elkstack']['config']['custom_logstash']['rabbitmq']['name'] = 'input_rabbitmq'
default['elkstack']['config']['custom_logstash']['rabbitmq']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['rabbitmq']['source'] = 'logstash/input_rabbitmq.conf.erb'
default['elkstack']['config']['custom_logstash']['rabbitmq']['variables'] = { path: '/var/log/rabbitmq/**' }

# Redis
default['elkstack']['config']['custom_logstash']['name'].push('redis')
default['elkstack']['config']['custom_logstash']['redis']['name'] = 'input_redis'
default['elkstack']['config']['custom_logstash']['redis']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['redis']['source'] = 'logstash/input_redis.conf.erb'
default['elkstack']['config']['custom_logstash']['redis']['variables'] = {}

# Varnish
default['elkstack']['config']['custom_logstash']['name'].push('varnish')
default['elkstack']['config']['custom_logstash']['varnish']['name'] = 'input_varnish'
default['elkstack']['config']['custom_logstash']['varnish']['cookbook'] = 'stack_commons'
default['elkstack']['config']['custom_logstash']['varnish']['source'] = 'logstash/input_varnish.conf.erb'
default['elkstack']['config']['custom_logstash']['varnish']['variables'] = { path: '/var/log/varnish/**' }
