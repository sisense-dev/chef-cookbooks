node.default[:elasticsearch][:plugin][:mandatory] = Array(node[:elasticsearch][:plugin][:mandatory] | ['HQ'])

install_plugin "royrusso/elasticsearch-HQ"