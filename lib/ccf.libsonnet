
{
  bashSnippets : {
    preamble(context) : |||
      #!/usr/bin/env bash
    |||,

    waitForContainerStatus(context, status) : |||
      printf "Waiting until %(containerName)s is '%(status)s'."
      while [ $(docker inspect --format "{{json .State.Status }}" %(containerName)s) != "\"%(status)s\"" ]; do printf "."; sleep 1; done
      echo " Done."
    ||| % { containerName : context.containerName, status : status },

    waitForContainerHealthStatus(context, status) : |||
      printf "Waiting until %(containerName)s is '%(status)s'."
      while [ $(docker inspect --format "{{json .State.Health.Status }}" %(containerName)s) != "\"%(status)s\"" ]; do printf "."; sleep 1; done
      echo " Done."
    ||| % { containerName : context.containerName, status : status },

    waitForContainerLogMessage(context, logMessage) : |||
      #!/bin/bash
      printf "Waiting until %(containerName)s is healthy via log output."
      docker logs -f %(containerName)s | while read LOGLINE
      do
        if [[ ${LOGLINE} = *"%(logMessage)s"* ]]; then
          break
        fi
      done
      echo ""
      echo "%(logMessage)s"
    ||| % { containerName : context.containerName, logMessage : logMessage },

    openHostFirewallPortName(context, portName) : |||
      sudo ufw allow %(portName)s
    ||| % { portName : portName },

    openHostFirewallPortNumber(context, port) : |||
      sudo ufw allow %(port)d
    ||| % { port : port },
  },

  makeTargets : {
    firewall(context, ports) : |||
      ## Check the firewall status for this container
      firewall:
        sudo ufw status verbose
    |||,
  },

  shellScripts: {
    waitForTCPPortAvailability: importstr "wait-for-tcp-port-availability.sh"
  },
}