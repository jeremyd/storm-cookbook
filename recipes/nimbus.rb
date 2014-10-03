include_recipe "storm"

node.set[:storm][:nimbus][:is_nimbus_host] = true

template "/etc/init/storm-nimbus.conf" do
  source "storm-upstart-conf.erb"
  variables({
    :storm_user => node.storm.deploy.user,
    :storm_home => "/home/#{node.storm.deploy.user}/apache-storm-#{node.storm.version}",
    :storm_service => "nimbus"
  })
  notifies :run, "execute[reload upstart configuration]", :immediately
end

service "storm-nimbus" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

logrotate_app "storm-nimbus" do
  frequency "daily"
  cookbook "logrotate"
  path "/var/log/storm/nimbus.log"
  rotate 30
  create "640 #{node.storm.deploy.user} #{node.storm.deploy.user}"
end
