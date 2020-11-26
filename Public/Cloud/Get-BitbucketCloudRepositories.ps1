
Function Get-BitbucketCloudRepositories {
    param(
        [Parameter(Mandatory=$false)] $Session = (Get-BitbucketSession),
        [Parameter(Mandatory=$true)] [String] $Workspace,
        $PageLen=100,
        $Page=1)
    $repositories= @();
    
    while($true){
        $request = Invoke-RestMethod `
            -Headers @{Authorization = $Session.Authorization } `
            -Uri "$($Session.Server)/$($Session.Version)/repositories/${Workspace}?pagelen=${PageLen}&page=${Page}"
        
        if(!$request.Values) {break;}

        $repositories += 
            $request.Values | Select-Object `
                @{n="Workspace";e={$Workspace}}, `
                @{n="Project";e={$_.project.name}}, `
                @{n="ProjectKey";e={$_.project.key}}, `
                @{n="FullName";e={ ($_.project.key,$_.slug) -join '/'}}, `
                @{n="Name";e={$_.slug}},`
                @{n="Updated";e={$_.updated_on}}, `
                @{n="Created";e={$_.created_on}},
                @{n="Rest";e={$_}}
        $Page++
    }
    return $repositories 
}