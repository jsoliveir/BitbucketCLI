Function New-BitbucketCloudCommit{
    param([Parameter(Mandatory=$false)] [PSCustomObject] $Session = (Get-BitbucketSession),
          [Parameter(Mandatory=$true)]  [String]    $Workspace,
          [Parameter(Mandatory=$true)]  [String]    $Repository,
          [Parameter(Mandatory=$false)] [String]    $Path,
          [Parameter(Mandatory=$false)] [String]    $Content,
          [Parameter(Mandatory=$false)] [String]    $Message,
          [Parameter(Mandatory=$false)] [String]    $Author,
          [Parameter(Mandatory=$false)] [String]    $Branch="master",
          [Parameter(Mandatory=$false)] [Switch]    $Delete
          )
          
      $body = @{
         message =$Message
         branch = [Uri]::EscapeDataString($Branch)
         author = $Author
      };
      
      if($Delete) { $Content = $null}

      if($Path){ $body.Add($Path, $Content) }

      return  (Invoke-RestMethod `
         -Method POST `
         -Uri "$($Session.Server)/$($Session.Version)/repositories/$Workspace/$Repository/src/" `
         -Headers @{ 
             Authorization = $Session.Authorization
             ContentType ='application/x-www-form-urlencode'
            } `
         -Body $body)
}