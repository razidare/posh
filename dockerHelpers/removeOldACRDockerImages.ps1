<#
.SYNOPSIS
    Deletes all images from all repositories in a given ACR, that are older than a specific number of months
.EXAMPLE
    ./removeOldACRDockerImages.ps1 -olderThanMonths 6 -acrName myAcr
#>

param (
    [Parameter(Mandatory=$true)][int]$olderThanMonths,
    [Parameter(Mandatory=$true)][string][ValidateNotNullOrEmpty()]$acrName
)

$referenceDate = [datetime]::Now.AddMonths(-$olderThanMonths).tostring("yyyy-MM-dd")

$allRepositories = az acr repository list -n $acrName -o json | ConvertFrom-Json

foreach ($repository in $allRepositories) {
    $allTags = az acr repository show-tags --repository $repository -n $acrName --detail | ConvertFrom-Json
    foreach ($tag in $allTags) {
        $imageName = "$repository`:$($tag.name)"
        if($referenceDate -gt $tag.createdTime){
            Write-Verbose "Deleting image $imageName" -vb
            az acr repository delete -n $acrName --image $imageName --yes
        }
        remove-variable imageName
    }
}