#
# Cookbook:: mongodb_cookbook_final
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'apt'

# bash 'install_mongodb.org' do
#   user 'root'
#   code <<-EOH
#   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
#   echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
#   sudo apt update
#   sudo apt install -y mongodb-org
#   sudo systemctl stop mongod.service
#   sudo systemctl start mongod.service
#   sudo systemctl enable mongod.service
#   EOH
# end


# THIS CODE WORKS FOR MONGOD VERSION 3.2.20
bash 'install_mongod' do
  user 'root'
  code <<-EOH
  wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
  echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20
  sudo systemctl restart mongod
  sudo systemctl enable mongod.service
  EOH
end

execute 'restart_mongod' do
  command 'sudo systemctl restart mongod'
  action :run
end

execute 'restart_mongod.service' do
  command 'sudo systemctl enable mongod.service'
  action :run
end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables bind_ip: node['mongod']['bind_ip'], port: node['mongod']['port']
  notifies :run, 'execute[restart_mongod]', :immediately
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  notifies :run, 'execute[restart_mongod.service]', :immediately
end

template '/opt/mongo/mongo-keyfile' do
  source 'mongo-keyfile.erb'
  mode '0400'
  notifies :run, 'execute[restart_mongod.service]', :immediately
end

directory '/opt/mongo' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


bash 'chown keyfile' do
  user 'root'
  code <<-EOH
  sudo chown mongodb:mongodb /opt/mongo/mongo-keyfile
  EOH
end


site_name = node['github']['repo']

include_recipe site_name
