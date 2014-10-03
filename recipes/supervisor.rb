include_recipe "storm"

node.set[:storm][:supervisor][:is_supervisor_host] = true

template "/etc/init/storm-supervisor.conf" do
  source "storm-upstart-conf.erb"
  variables({
    :storm_user => node.storm.deploy.user,
    :storm_home => "/home/#{node.storm.deploy.user}/apache-storm-#{node.storm.version}",
    :storm_service => "supervisor"
  })
  notifies :run, "execute[reload upstart configuration]", :immediately
end

service "storm-supervisor" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

logrotate_app "storm-supervisor" do
  frequency "daily"
  cookbook "logrotate"
  path "/var/log/storm/supervisor.log"
  rotate 30
  create "640 #{node.storm.deploy.user} #{node.storm.deploy.user}"
end
