directory '/usr/share/backups-scripts' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file 'daily-backup-kibana.sh' do
	mode '0755'
	path "/usr/share/backups-scripts/daily-backup-kibana.sh"
	action :create_if_missing
end

cookbook_file 'daily-backup-elasticsearch.sh' do
	mode '0755'
	path "/usr/share/backups-scripts/daily-backup-elasticsearch.sh"
	action :create_if_missing
end

cron_d 'es-daily-backup' do
  minute  30
  hour    18
  #command '/usr/share/backups-scripts/daily-backup-elasticsearch.sh'
  command 'test1'
  user    'root'
end

cron_d 'kibana-daily-backup' do
  minute  30
  hour    19
  #command '/usr/share/backup-scripts/daily-backup-kibana.sh'
  command 'test2'
  user    'root'
end