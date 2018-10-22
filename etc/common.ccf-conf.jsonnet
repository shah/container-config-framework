local systemFacts = import "system-localhost.ccf-facts.json";

{
  domainName: 'appliance.local',
  defaultDockerNetworkName : 'appliance',
  
  applianceName: systemFacts.hostname,
  applianceHostName: $.applianceName,
  applianceFQDN: $.applianceHostName + '.' + $.domainName,
}