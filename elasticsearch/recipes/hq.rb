node.default[:elasticsearch][:plugin][:mandatory] = Array(node[:elasticsearch][:plugin][:mandatory] | ['hq'])

install_plugin "royrusso/elasticsearch-HQ"

service 'elasticsearch' do:
	action :restart
end

