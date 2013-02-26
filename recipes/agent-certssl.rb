include_recipe "zabbix::agent"

cookbook_file "/etc/zabbix/externalscripts/certssl_check.sh" do
  source "zabbix/server/certssl/certssl_check.sh"
  owner  "zabbix"
  group  "root"
  mode   "0750"
end

cookbook_file "/etc/zabbix/agentd.d/certssl.conf" do
  source "zabbix/server/certssl/certssl.conf"
  owner  "zabbix"
  group  "root"
  mode   "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

