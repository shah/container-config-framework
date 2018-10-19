local hostPrimaryEthernetInterfaceFacts = import "eth0-interface-localhost.ccf-facts.json";

{
  domainName: 'appliance.local',
  applianceName: 'barge',
  applianceHostName: $.applianceName,
  applianceFQDN: $.applianceHostName + '.' + $.domainName,
  defaultDockerNetworkName : 'appliance',
  defaultDockerHostIPAddr : hostPrimaryEthernetInterfaceFacts.address,
}