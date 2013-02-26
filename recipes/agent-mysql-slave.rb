include_recipe "zabbix::agent-mysql"

template "/etc/zabbix/externalscripts/mysql_slave.sh" do
  source "mysql/slave_status.sh.erb"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/mysql-slave.conf" do
        source "mysql/mysql-slave.conf"
        owner "zabbix"
        group "root"
        mode "0640"
        notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end
