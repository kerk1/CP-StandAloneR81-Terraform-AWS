#!/bin/bash
clish -c 'set user admin shell /bin/bash' -s
clish -c 'set static-route 10.0.5.0/24 nexthop gateway address 10.0.2.1 on' -s
config_system -s 'install_security_gw=true&install_ppak=true&gateway_cluster_member=false&install_security_managment=true&install_mgmt_primary=true&install_mgmt_secondary=false&download_info=true&hostname=R81mgmt&mgmt_gui_clients_radio=any&mgmt_admin_radio=gaia_admin'
/opt/CPvsec-R81/bin/vsec on
sleep 5

#Setup Initial file to wait for R81 to be ready and setup the API/Rules after the first boot
cat <<EOT >> /etc/rc.local
## This is only used once for initial setup of the AWS instance
if [[ -f "/home/admin/R81setup" ]]
then
/home/admin/R81setup
fi
EOT

touch /home/admin/R81setup
chmod 755 /home/admin/R81setup
cat <<EOT >> /home/admin/R81setup
#!/bin/bash
# Wait for the API server to come ready before sending API commands
while true; do
    status=\$(api status |grep 'API readiness test SUCCESSFUL. The server is up and ready to receive connections' |wc -l)
    echo "Checking if the API is ready"
    if [[ ! \$status == 0 ]]; then
         break
    fi
       sleep 15
    done
echo "API ready " \$(date)
sleep 5
# Login and get the topology on the gateway and enable some Software Blades
GATEWAYUID=\$(mgmt_cli -r true show-simple-gateway name R81mgmt -f json |jq '.uid')
mgmt_cli -r true get-interfaces with-topology true target-uid \$GATEWAYUID
mgmt_cli -r true set-simple-gateway name R81mgmt application-control true url-filtering true ips true anti-bot true anti-virus true
mv /home/admin/R81setup /home/admin/R81setup.old
EOT
reboot