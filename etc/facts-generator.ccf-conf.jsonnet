{
  osQueries: {
    singleRow : [
      { name: "system-localhost", query: "select * from system_info" }
      { name: "eth0-interface-localhost", query: "select * from interface_addresses where interface = 'eth0'" }
    ],
    multipleRows : [
      { name: "interfaces-localhost", query: "select * from interface_addresses" }
    ],
  },

  shellEvals: 
  [
    { name: "docker-localhost", key: "dockerHostIPAddress", evalAsTextValue: "/sbin/ip -4 -o addr show dev eth0 | awk '{split($4,a,\"/\");print a[1]}'" },
    { name: "docker-localhost", key: "dockerBridgeNetworkGatewayIPAddress", evalAsTextValue: "docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge" },
  ],
}