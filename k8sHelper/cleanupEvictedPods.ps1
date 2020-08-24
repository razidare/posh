$allPods=kubectl get pods --all-namespaces -o=json | ConvertFrom-Json

foreach ($pod in $allPods.items) {
    if ( $pod.status.reason -eq "Evicted") {
        Write-Verbose "Deleting pod $($pod.metadata.name) from namespace $($pod.metadata.namespace)" -vb
        kubectl delete po $pod.metadata.name --namespace $pod.metadata.namespace
    }
}