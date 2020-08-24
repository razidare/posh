<#
.SYNOPSIS
    Scales all deployments in the cluster except for kube-system and kube-node-lease namespaces to a given number of replicas
.EXAMPLE
    ./scaleDeploymentReplicas.ps1 -replicas 3
#>
param(
    [int]$replicas=1
)
$namespaces = (kubectl get namespace -o json | ConvertFrom-Json).items.metadata.name
$baseMessage = "doing nothing in namespace:"

foreach($namespace in $namespaces){
    switch($namespace){
        'kube-system'{
            Write-Verbose "$baseMessage kube-system" -Verbose
        }
        'kube-node-lease'{
            Write-Verbose "$baseMessage kube-node-lease" -Verbose
        }
        default {
            $deployments = (kubectl get deployment -n $namespace -o json | ConvertFrom-Json).items.metadata.name
            foreach($deployment in $deployments){
                if((kubectl get deployment $deployment -n $namespace -o json | ConvertFrom-Json).status.replicas -eq $replicas){
                    Write-Verbose "deployment $deployment already on $replicas replica(s)" -Verbose
                } else{
                    kubectl scale deployment $deployment --replicas=$replicas -n $namespace
                }
            }
        }
    }
}