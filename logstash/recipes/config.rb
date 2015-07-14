cookbook_file 'settings.conf' do
	mode '0644'
	path "/opt/logstash/server/etc/conf.d/settings.conf"
	action :create_if_missing
end

#template "/opt/logstash/server/etc/conf.d/settings.conf" do
#  source "settings.erb"
#end
