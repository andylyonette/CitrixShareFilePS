function Get-CitrixShareFileAccessControl{
    [CmdletBinding()]
    param(
        [Parameter(Mandatoryalse, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Organisation,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$User,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Item,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Organisation.sharefile.com/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "AccessControls(principalid=$($User.Id),itemid=$($Item.Id)")  -ContentType "application/json" -Headers $headers -UseBasicParsing -ErrorAction Stop
}

function Get-CitrixShareFileHomeFolder{
    [CmdletBinding()]
    param(
        [Parameter(Mandatoryalse, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Organisation,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Organisation.sharefile.com/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + 'Items') -ContentType "application/json" -Headers $headers -UseBasicParsing -ErrorAction Stop
}

function Get-CitrixShareFileTokenWithPassword{
    [CmdletBinding()]
    param(
        [Parameter(Mandatoryalse, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Organisation,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ClientId,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Secret,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [securestring]$Password
    )

    $shareFileEndpoint = "https://$Organisation.sharefile.com/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "oauth/token?grant_type=password&client_id=$ClientId&client_secret=$Secret&username=$Username&password=$($Password | ConvertFrom-SecureString -AsPlainText)") -ContentType "application/x-www-form-urlencoded" -UseBasicParsing -ErrorAction Stop
}

function New-CitrixShareFileFolder{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$ParentFolder,

        [Parameter(Mandatory = $false, Position=3)]
        [DateTime]$Expiry,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $body = @{
        Name = $Name
        Description= $Description
    }

    if ($Expiry) {
        $body += @{
            ExpirationDate = $Expiry.ToString()
        }
    }

    return Invoke-RestMethod -Method Post -Uri "$($ParentFolder.url)/Folder" -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing -ErrorAction Stop

}

function Get-CitrixShareFileUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Organisation,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Organisation.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "Users?emailaddress=$EmailAddress") -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Invoke-CitrixShareFileUpload{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$ParentFolder,

        [Parameter(Mandatory = $false, Position=3)]
        [DateTime]$Expiry,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $file = Get-Item -Path $Path -ErrorAction Stop

    $body = @{
        Method = "Method"
        Raw = $true
        FileName = "$($file.Name)"
        FileSize = $($file.Length)
    } | ConvertTo-Json
    
    $uploadFileRequest = Invoke-RestMethod -Method Post -Uri "$($ParentFolder.url)/Upload" -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing -ErrorAction Stop

    $form = @{
        FileData = $file
    }

    return Invoke-RestMethod -Method Post -Uri $uploadFileRequest.ChunkUri -Form $form -Headers $headers -ContentType 'multipart/form-data'
}

function New-CitrixShareFileUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Organisation,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$FirstName,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$LastName,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Company,

        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Organisation.sf-api.com/sf/v3/"

    $body = @{
        Email = $EmailAddress
        FirstName= $FirstName
        LastName = $LastName
        Company = $Company
    } | ConvertTo-Json
    
    return Invoke-WebRequest -Method Post -Uri ($shareFileEndpoint + 'Users') -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Send-CitrixShareFileUserWelcomeEmail{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Organisation,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$User,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Organisation.sf-api.com/sf/v3/"

    $body = @{
        CustomMessage = $Message
        NotifySender = $false
    } | ConvertTo-Json
    
    return Invoke-RestMethod -Method Post -Uri ($shareFileEndpoint + "Users($User.Id)/WelcomeNotification") -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing
}
