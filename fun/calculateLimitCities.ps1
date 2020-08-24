<#
.SYNOPSIS
    Function that generates a list of cities with properties: name, countryOfProvenience, latitude, longitude
.EXAMPLE
    New-CityList -thisManyCities 50
#>
function New-CityList {
    param (
        [int]$thisManyCities
    )
    $completeCityList = [System.Collections.ArrayList]::new()

    for($i=0;$i -lt $thisManyCities;$i++) {
        $cityName                   = ""
        (65..90) + (97..122) | Get-Random -Count 10 | % { [string]$cityName+=[char]$_}
        $countryOfProvenience       = ("Romania","Pakistan","India","UK","France","Belgium") | Get-random
        $latitude                   = [math]::Round($(Get-Random -Minimum 23.04 -Maximum 43.29),2)
        $longitude                  = [math]::Round($(Get-Random -Minimum 10.35 -Maximum 35.98),2)

    <#    [hashtable]$currentCity = @{}

        $currentCity.Add("Name",$cityName)
        $currentCity.Add("Country",$countryOfProvenience)
        $currentCity.Add("Latitude",$latitude)
        $currentCity.Add("Longitude",$longitude)

        $completeCityList += New-Object -TypeName psobject -Property $currentCity
    #>
        $completeCityList += [PSCustomObject]@{
            Name        = $cityName
            Country     = $countryOfProvenience
            Latitude    = $latitude
            Longitude   = $longitude
        }
    }

    return $completeCityList
}

#Filter all the romanian cities in the list
$romanianCities = New-CityList -thisManyCities 100 | where Country -eq Romania

#Find the maximums and minimums for latitude and longitude
$maxLat     = ($romanianCities | Measure-Object -Property Latitude -Maximum).Maximum
$minLat     = ($romanianCities | Measure-Object -Property Latitude -Minimum).Minimum
$maxLong    = ($romanianCities | Measure-Object -Property Longitude -Maximum).Maximum
$minLong    = ($romanianCities | Measure-Object -Property Longitude -Minimum).Minimum

#Find most extreme cities
Write-Output "Most northern city from $(($romanianCities | ? { $_.Latitude -eq $maxLat}).Country) is $(($romanianCities | ? { $_.Latitude -eq $maxLat}).Name)"
Write-Output "Most southern city from $(($romanianCities | ? { $_.Latitude -eq $minLat}).Country) is $(($romanianCities | ? { $_.Latitude -eq $minLat}).Name)"
Write-Output "Sun rises in $(($romanianCities | ? { $_.Longitude -eq $maxLong}).Country) in $(($romanianCities | ? { $_.Longitude -eq $maxLong}).Name)"
Write-Output "Sun setes in $(($romanianCities | ? { $_.Longitude -eq $minLong}).Country) in $(($romanianCities | ? { $_.Longitude -eq $minLong}).Name)"

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
