#node.default[:elasticsearch][:plugin][:mandatory] = Array(node[:elasticsearch][:plugin][:mandatory] | ['cloud-aws'])

#install_plugin "elasticsearch/elasticsearch-cloud-aws/#{node.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version']}"

install_plugin 'cloud-aws', 'url' => 'https://github.com/elastic/elasticsearch-cloud-aws/master.zip'
