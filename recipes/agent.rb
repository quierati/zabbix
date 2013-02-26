#
# Cookbook Name:: zabbix
# Recipe:: agent
#
# Copyright 2012, Labunix.com
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "debian", "ubuntu"
  package "zabbix-agent" do
    options "--force-yes"
  end

when "fedora", "centos", "redhat"
  package "zabbix"
  package "zabbix-agent"
  package "zabbix-sender"

  directory "/var/run/zabbix" do
    owner "zabbix"
    group "root"
    mode "0750"
    action :create
    recursive true
  end

  link "/etc/init.d/zabbix-agent" do 
    to "/etc/init.d/zabbix-agentd"
  end
end
  
group "adm" do
  gid 4
  group_name "adm"
  members "zabbix"
  append true
end


service "zabbix-agent" do
  supports :restart => true, :reload => true
  action [ :enable , :start]
end

template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  owner "zabbix"
  group "root"
  mode "0600"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

directory "/etc/zabbix/agentd.d" do
  owner "zabbix"
  group "root"
  mode "0750"
  action :create
  recursive true
end

directory "/etc/zabbix/externalscripts" do
  owner "zabbix"
  group "root"
  mode "0750"
  action :create
  recursive true
end

directory "/etc/zabbix/zabbix_agentd.conf.d" do
	action :delete
	only_if do File.exist?("/etc/zabbix/zabbix_agentd.conf.d") end
end
