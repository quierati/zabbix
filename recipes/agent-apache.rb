include_recipe "zabbix::agent"

package "nagios-plugins-basic" do
   options "--force-yes"
end

template "/etc/zabbix/externalscripts/apache_status.py" do
  source "apache/apache_status.py.erb"
  owner  "zabbix"
  group  "root"
  mode   "0750"
end

template "/etc/zabbix/externalscripts/apache_log.sh" do
  source "apache/apache_log.sh"
  owner  "zabbix"
  group  "root"
  mode   "0750"
end

cookbook_file "/etc/zabbix/agentd.d/apache.conf" do
  source "apache/apache.conf"
  owner  "zabbix"
  group  "root"
  mode   "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

cookbook_file "/etc/zabbix/agentd.d/apachelog.conf" do
  source "apache/apachelog.conf"
  owner  "zabbix"
  group  "root"
  mode   "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

cookbook_file "/etc/zabbix/agentd.d/httpcheck.conf" do
  source "apache/httpcheck.conf"
  owner  "zabbix"
  group  "root"
  mode   "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

