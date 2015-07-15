execute 'clean-yum-cache' do
  command "curator delete --older-than #{node['elasticsearch']['days-to-delete']}"
end