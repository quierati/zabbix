include_recipe "zabbix::agent"

#group "adm" do
#  action :modify
#  members "zabbix"
#  append true
#end

package "logtail" do
   options "--force-yes"
end

package "pflogsumm" do
   options "--force-yes" 
end

template "/etc/zabbix/externalscripts/postfix_status.sh" do
  source "postfix/postfix_status.sh.erb"
  owner "zabbix"
  group "root"
  mode "0750"
end

cookbook_file "/etc/zabbix/agentd.d/postfix.conf" do
  source "postfix/postfix.conf"
  owner "zabbix"
  group "root"
  mode "0640"
  notifies :restart, resources(:service => "zabbix-agent" ), :delayed
end

