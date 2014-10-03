template "Storm conf file" do
  path "/home/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}/conf/storm.yaml"
  source "storm.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
end