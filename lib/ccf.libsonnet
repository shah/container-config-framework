{
  waitForContainerHealthStatus(containerConf, status) : |||
    #!/bin/bash
    printf "Waiting until %(containerName)s is '%(status)s'."
    while [ $(docker inspect --format "{{json .State.Health.Status }}" %(containerName)s) != "\"%(status)s\"" ]; do printf "."; sleep 1; done
    echo " Done."
  ||| % { containerName : containerConf.containerName, status : status },
}