include_recipe "zabbix::agent"

template "/etc/zabbix/externalscripts/varnish_status.sh" do
    source "varnish/varnish_status.sh.erb"
    owner "zabbix"
    group "root"
    mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/varnish.conf" do
        source "varnish/varnish.conf"
        owner "zabbix"
        group "root"
        mode "0640"
        notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end


