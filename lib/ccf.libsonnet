
{
  bashSnippets : {
    preamble(context) : |||
      #!/usr/bin/env bash
    |||,

    waitForContainerHealthStatusBashSnippet(context, status) : |||
      printf "Waiting until %(containerName)s is '%(status)s'."
      while [ $(docker inspect --format "{{json .State.Health.Status }}" %(containerName)s) != "\"%(status)s\"" ]; do printf "."; sleep 1; done
      echo " Done."
    ||| % { containerName : context.containerName, status : status },

    openHostFirewallPortName(context, portName) : |||
      sudo ufw allow %(portName)s
    ||| % { portName : portName },

    openHostFirewallPortNumber(context, port) : |||
      sudo ufw allow %(port)d
    ||| % { port : port },
  },
}