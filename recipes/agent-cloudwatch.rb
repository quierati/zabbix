include_recipe "zabbix::agent"

package "python-boto" do
	options "--force-yes"
end

cookbook_file "/etc/zabbix/externalscripts/aws2zabbix.py" do
  source "zabbix/server/cloudwatch/aws2status.py"
  owner  "zabbix"
  group  "root"
  mode   "0750"
end

cookbook_file "/etc/zabbix/agentd.d/apache.conf" do
  source "zabbix/server/cloudwatch/cloudwatch.conf"
  owner  "zabbix"
  group  "root"
  mode   "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

