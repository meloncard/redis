#
# Cookbook Name:: redis
# Recipe:: _server_config

## This is copied from server_service
# Need to figure out a good way to make this work, that allows reconfigure -HGH
redis_service = case node['platform']
when "ubuntu", "debian"
  "redis-server"
when "centos", "redhat"
  "redis"
else
  "redis"
end

service "redis" do
  service_name redis_service
  action :nothing
end
##/copy

directory node['redis']['conf_dir'] do
  owner "root"
  group "root"
  mode 0755
end

directory node['redis']['config']['dir'] do
  owner node['redis']['user']
  group node['redis']['group']
  mode 0755
end

template "#{node['redis']['conf_dir']}/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables node['redis']['config']
  notifies :restart, resources(:service => 'redis'), :delayed
end
