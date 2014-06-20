include_recipe "storm"

template "Storm conf file" do
  path "/home/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}/conf/storm.yaml"
  source "ui.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
end

template "/etc/init/storm-ui.conf" do
  source "storm-upstart-conf.erb"
  variables({
    :storm_user => node.storm.deploy.user,
    :storm_home => "/home/#{node.storm.deploy.user}/apache-storm-#{node.storm.version}",
    :storm_service => "ui"
  })
  notifies :run, "execute[reload upstart configuration]", :immediately
end

service "storm-ui" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
