<#
.SYNOPSIS
    replaces #{variable}# with "value", as long as $variable="value"
.EXAMPLE
    ./replaceTokens.psq -filePath ./test.yml -leftPattern #[ -rightPattern ]#
#>

param(
    #provide path of a file which contains variables tokenized as "#{variable}#"
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$filePath,
    [ValidateNotNullOrEmpty()][string]$leftPattern="#{",
    [ValidateNotNullOrEmpty()][string]$rightPattern="}#"
)

$regexPattern = "$leftPattern(.*?)$rightPattern"

#read file
#find all lines that contain tokenized pattern
$content = Get-Content $filePath
$linesWithVariables = $content | Select-String -Pattern $leftPattern
$variablesToReplace = @()

#match regex on each line of code in the file, select groups without patterns
foreach($line in $linesWithVariables) {
    $string = $line.toString()
    #ignore commented lines
    if(!$string.startsWith('#')) {
        #get all variables from within tokens
        $variablesToReplace += [regex]::matches($string,$regexPattern).Groups.Value | where { ! $_.StartsWith($leftPattern) } 
    }
}

foreach ($variable in $variablesToReplace) {
    #get variable and value from PS context
    $contextVariable = Get-ChildItem Variable:,ENV: |  where name -eq $variable | select name, value -unique
    if (![string]::IsNullOrEmpty($contextVariable)) {
        $variableValue= $contextVariable.Value
        Write-Verbose "replacing token $leftPattern$variable$rightPattern with $variableValue ..." -vb
        $content = $content -replace "$leftPattern$variable$rightPattern", $variableValue
    }
    else { 
        Write-Warning "no variable for $variable was found neither in Variable: nor ENV: providers"
    }
}
#write modified file back
$content | Set-Content $filePath