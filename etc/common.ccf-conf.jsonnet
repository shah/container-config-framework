local systemFacts = import "system-localhost.ccf-facts.json";
local dockerFacts = import "docker-localhost.ccf-facts.json";

{
  domainName: 'appliance.local',
  defaultDockerNetworkName : 'appliance',
  
  applianceName: systemFacts.hostname,
  applianceHostName: $.applianceName,
  applianceFQDN: $.applianceHostName + '.' + $.domainName,
  dockerHostIPAddr : dockerFacts.dockerHostIPAddress,
  dockerBridgeNetworkGatewayIPAddress : dockerFacts.dockerBridgeNetworkGatewayIPAddress,
}