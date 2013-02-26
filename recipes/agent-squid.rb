include_recipe "zabbix::agent"

template "/etc/zabbix/externalscripts/squid_status.pl" do
  source "squid/squid_status.pl.erb"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/squid.conf" do
  source "squid/squid.conf"
  owner "zabbix"
  group "root"
  mode "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

