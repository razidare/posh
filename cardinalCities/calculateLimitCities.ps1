$romanianCities = ./generateCities.ps1 -thisManyCities 100 | where Country -eq Romania

$maxLat     = ($romanianCities | Measure-Object -Property Latitude -Maximum).Maximum
$minLat     = ($romanianCities | Measure-Object -Property Latitude -Minimum).Minimum
$maxLong    = ($romanianCities | Measure-Object -Property Longitude -Maximum).Maximum
$minLong    = ($romanianCities | Measure-Object -Property Longitude -Minimum).Minimum

Write-Output "Most northern city from $(($romanianCities | ? { $_.Latitude -eq $maxLat}).Country) is $(($romanianCities | ? { $_.Latitude -eq $maxLat}).Name)"
Write-Output "Most southern city from $(($romanianCities | ? { $_.Latitude -eq $minLat}).Country) is $(($romanianCities | ? { $_.Latitude -eq $minLat}).Name)"
Write-Output "Most eastern city from $(($romanianCities | ? { $_.Longitude -eq $maxLong}).Country) is $(($romanianCities | ? { $_.Longitude -eq $maxLong}).Name)"
Write-Output "Most western city from $(($romanianCities | ? { $_.Longitude -eq $minLong}).Country) is $(($romanianCities | ? { $_.Longitude -eq $minLong}).Name)"

<#$romanianCities | ForEach-Object -begin {
    $longitudeMax  = 0
    $latitudeMax   = 0
    $longitudeMin  = 10000
    $latitudeMin   = 10000
} -process {
    if($_.Latitude -gt $latitudeMax) {
        $latitudeMax   = $_.Latitude
        $maxLatCity    = $_
    }
    if($_.Longitude -gt $longitudeMax) {
        $longitudeMax   = $_.Longitude
        $maxLongCity    = $_
    }
    if($_.Latitude -lt $latitudeMin) {
        $latitudeMin   = $_.Latitude
        $minLatCity    = $_
    }
    if($_.Longitude -lt $longitudeMin) {
        $longitudeMin   = $_.Longitude
        $minLongCity    = $_
    }
} -end {
    Write-Output "Most northern city from $($maxLatCity.Country) is $($maxLatCity.Name)"
    Write-Output "Most southern city from $($minLatCity.Country) is $($minLatCity.Name)"
    Write-Output "Most eastern city from $($maxLongCity.Country) is $($maxLongCity.Name)"
    Write-Output "Most western city from $($minLongCity.Country) is $($minLongCity.Name)"
} #>
