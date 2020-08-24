<#
.SYNOPSIS
    Joke function with purpose of showcasing more complex constructs in powershell
.EXAMPLE
    "ana", "mircea", 'razvan', 'radu' | isNoob

.EXAMPLE
    "ana", "mircea", 'razvan', 'radu' | isNoob -whatif

.EXAMPLE
    isNoob -persons "ana", "mircea", 'razvan', 'radu'
#>
function Get-NoobnessLevel {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [Alias("isNoob")]
    param (
        [Parameter(ValueFromPipeline=$true)][string[]]$persons
    )

    begin{
        Write-Verbose "start" -vb
        $operation = "Check the noobness level"
        $notNoobs = @("Radu")
        $megaNoobs = @("Razvan")
    }

    process{
        foreach ($person in $persons) {
            if ($pscmdlet.ShouldProcess($person, $operation)) {
                switch ($person) {
                    {$_ -in $megaNoobs} { Write-Verbose "$person is mega noob" -vb }
                    {$_ -in $notNoobs} { Write-Error "impossibru!" -ea Continue}
                    default { Write-Warning "cannot tell if $person is noob or not" }
                }
            }
        }
    }

    end{
        Write-Verbose "stop" -vb
    }
}