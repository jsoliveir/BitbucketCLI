
Function Get-BitbucketCloudContent{
    param(
          [Parameter(Mandatory=$false)] $Session = (Get-BitbucketSession),
          [Parameter(Mandatory=$false)] [String] $Workspace = $Session.Workspace,
          [Parameter(Mandatory=$true)] [String] $Repository,
          [Parameter(Mandatory=$false)] [String] $Path = "/",
          [Parameter(Mandatory=$false)] [String] $Commit="master",
          [Parameter(Mandatory=$false)] [Int] $PageLen=100
    )

    $branch = Get-BitbucketCloudBranches `
        -Session $Session `
        -Workspace $Workspace `
        -Repository $Repository `
        -ErrorAction SilentlyContinue `
    | Where-Object name -imatch "$Commit" `
    | Select-Object -First 1

    if($branch) { $Commit = $branch.target.hash }
    $Path = $Path -replace "\\","/"
    $Path = $Path -replace "^/",""
    $Path = $Path -replace "^\.\/",""

    $request = (Invoke-WebRequest `
        -Uri "$($Session.Server)/$($Session.Version)/repositories/${Workspace}/${Repository}/src/${Commit}/${Path}?q=${Query}&pagelen=${PageLen}" `
        -ContentType "application/json;charset=utf-8" `
        -UseBasicParsing `
        -Headers @{
            Authorization = $Session.Authorization
        })
    
        try{
            $json = ($request.Content | ConvertFrom-Json -ErrorAction SilentlyContinue);
        }catch{
            if($VerbosePreference){
                Write-Host -ForegroundColor DarkGray $_
            }
        }
        
        if($json.values.path){
            return $json.values
        }else{
            return $request.Content
        }        
}