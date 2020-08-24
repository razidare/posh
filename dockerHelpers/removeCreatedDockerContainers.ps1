$dockerContainers = $(docker ps -a --format "{{.ID}}:{{.Status}}")

foreach ($container in $dockerContainers) {
    if ($container -like "*Created*") {
        $(docker rm $container.split(":")[0])
    }
}