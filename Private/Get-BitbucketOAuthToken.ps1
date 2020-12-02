Function Get-BitbucketOAuthToken {
    param([Parameter(Mandatory=$false)] [String] $Username,
          [Parameter(Mandatory=$false)] [SecureString] $Password,
          [Parameter(Mandatory=$false)] [String] $Token = (Get-BitbucketCloudOAuthToken $Username $Password))
    return  $Token;
}

