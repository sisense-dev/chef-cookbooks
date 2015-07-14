# stop service
#
service 'kibana' do
  action :stop
end

# delete all kibana directories
#
[node['kibana']['path']['conf'], node['kibana']['path']['logs'], node['kibana']['pid_path'], node['kibana']['dir']].each do |path|
  directory path do
    recursive true
    action :delete
  end
end


# delete service
#
file node['kibana']['service_file'] do
  path node['kibana']['service_file_path']
  action :delete
end

