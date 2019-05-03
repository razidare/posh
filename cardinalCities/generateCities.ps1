param (
    [int]$thisManyCities
)
$completeCityList = [System.Collections.ArrayList]::new()

for($i=0;$i -lt $thisManyCities;$i++) {
    $cityName                   = ""
    (65..90) + (97..122) | Get-Random -Count 10 | %{ [string]$cityName+=[char]$_}
    $countryOfProvenience       = ("Romania","Pakistan","India","UK") | Get-random
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