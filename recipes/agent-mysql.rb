include_recipe "zabbix::agent"

template "/etc/zabbix/externalscripts/mysql_status.sh" do
  source "mysql/mysql_status.sh.erb"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/mysql.conf" do
        source "mysql/mysql.conf"
        owner "zabbix"
        group "root"
        mode "0640"
        notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

