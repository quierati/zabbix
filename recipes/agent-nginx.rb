include_recipe "zabbix::agent"

template "/etc/zabbix/externalscripts/nginx_status.sh" do
  source "nginx/nginx_status.sh.erb"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/nginx.conf" do
        source "nginx/nginx.conf"
        owner "zabbix"
        group "root"
        mode "0750"
        notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end
