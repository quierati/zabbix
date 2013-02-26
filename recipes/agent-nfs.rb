include_recipe "zabbix::agent"

template "/etc/zabbix/externalscripts/nfs_server.pl" do
   source "nfs/nfs_server.pl.erb"
   owner "zabbix"
   group "root"
   mode "0750"
end

cookbook_file "/etc/zabbix/externalscripts/nfs_mountpoint.sh" do
  source "nfs/nfs_mountpoint.sh"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/nfs.conf" do
  source "nfs/nfs.conf"
  owner "zabbix"
  group "root"
  mode "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

