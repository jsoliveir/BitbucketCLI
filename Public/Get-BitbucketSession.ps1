Function Get-BitbucketSession {
    param(
          [Parameter(Mandatory=$false)] [String] $Id = "*",
          [Parameter(Mandatory=$false)] [String] $Server = "*",
          [Parameter(Mandatory=$false)] [Switch] $All)

    $Sessions = $global:BITBUCKETCLI_SESSIONS.Values
    
    if(!$All){
        $Sessions =  $Sessions `
        | Where-Object { $_.Server -like "$Server" -and  $_.Id -like "$Id" } `
        | Select-Object -Last 1
    }

    if(!$Sessions){
        Write-Warning "No sessions have been created."
    }
    return $Sessions
}

