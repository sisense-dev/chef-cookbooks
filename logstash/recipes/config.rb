cookbook_file 'settings.conf' do
	path "/opt/logstash/server/etc/conf.d/settings.conf"
	action :create_if_missing
end
