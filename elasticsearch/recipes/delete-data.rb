execute 'clean-yum-cache' do
  command "curator delete --older-than #{node['days-to-delete']}"
end