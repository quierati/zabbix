include_recipe "zabbix::agent"

cookbook_file "/etc/sudoers.d/119-group-zabbix" do
  source "rabbitmq/zabbix_sudo"
  owner "root"
  group "root"
  mode "0440"
end

template "/etc/zabbix/externalscripts/rabbitqueue_status.sh" do
  source "rabbitmq/rabbitqueue_status.sh.erb"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/rabbitmq.conf" do
  source "rabbitmq/rabbitmq.conf"
  owner "zabbix"
  group "root"
  mode "0750"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

