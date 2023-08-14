function Deploy-CitrixShareFileFolderTemplate{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Folder,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Template,

        [Parameter(Mandatory = $false, Position=3)]
        [int]$BatchSize = 10,

        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Post -Uri ($shareFileEndpoint + "FolderTemplates($(Template.Id)/BulkApply?folderId=$($Folder.Id)&batchSize=$BatchSize")  -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Get-CitrixShareFileAccessControl{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,

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

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "AccessControls(principalid=$($User.Id),itemid=$($Item.Id)")  -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Get-CitrixShareFileFolderTemplate{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Id,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    if ($Id) {
        $uri = $shareFileEndpoint + "FolderTemplates($Id)"
    } else {
        $uri = $shareFileEndpoint + 'FolderTemplates()'
    }
    return Invoke-RestMethod -Method Get -Uri $uri -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Get-CitrixShareFileHomeFolder{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + 'Items') -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Get-CitrixShareFileItem{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
 
        [Parameter(Mandatory = $false, Position=2)]
        [switch]$IncludeDeleted,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "Items($ItemId)?includeDeleted=$IncludeDeleted") -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Get-CitrixShareFileItemByPath{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
 
        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
 
        [Parameter(Mandatory = $false, Position=2)]
        [switch]$IncludeDeleted,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "Items/ByPath?path=$Path") -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Get-CitrixShareFileTokenWithPassword{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
 
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

    $shareFileEndpoint = "https://$Account.sharefile.com/"

    return Invoke-RestMethod -Method Get -Uri ($shareFileEndpoint + "oauth/token?grant_type=password&client_id=$ClientId&client_secret=$Secret&username=$Username&password=$($Password | ConvertFrom-SecureString -AsPlainText)") -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
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
    } | ConvertTo-Json

    if ($Expiry) {
        $body += @{
            ExpirationDate = $Expiry.ToString()
        }
    }

    return Invoke-RestMethod -Method Post -Uri "$($ParentFolder.url)/Folder" -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing

}

function New-CitrixShareFileFolderTemplate{
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
        [psobject]$Items,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $body = @{
        Name = $Name
        Description= $Description
        Items = $Items
    } | ConvertTo-Json

    return Invoke-RestMethod -Method Post -Uri "$($ParentFolder.url)/FolderTemplates" -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing

}

function Get-CitrixShareFileUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Account,
 
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

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

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

function New-CitrixShareFileAccessControl{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,

        [Parameter(Mandatory, Position=1)]
        [ValidateNotNullOrEmpty()]
        [psobject]$User,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Item,

        [Parameter(Mandatory, Position=3)]
        [ValidateNotNullOrEmpty()]
        [bool]$CanUpload,
        
        [Parameter(Mandatory, Position=4)]
        [ValidateNotNullOrEmpty()]
        [bool]$CanDownload,
        
        [Parameter(Mandatory, Position=5)]
        [ValidateNotNullOrEmpty()]
        [bool]$CanView,
        
        [Parameter(Mandatory, Position=6)]
        [ValidateNotNullOrEmpty()]
        [bool]$CanDelete,
        
        [Parameter(Mandatory, Position=7)]
        [ValidateNotNullOrEmpty()]
        [bool]$CanManagePermissions,
        
        [Parameter(Mandatory = $false, Position=8)]
        [string]$Message,
        
        [Parameter(Mandatory = $false, Position=9)]
        [switch]$Recursive,
        
        [Parameter(Mandatory, Position=10)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    $body = @{
        Principal= @{url = $User.url} 
        CanUpload = $CanUpload
        CanDownload = $CanDownload
        CanView = $CanView
        CanDelete = $CanDelete
        CanManagePermissions = $CanManagePermissions
    }
    
    if ($Message) {
        $body += @{
            Message = $Message
        }
    }
    
    $body = $body | ConvertTo-Json

    return Invoke-RestMethod -Method Post -Body $body -Uri ($shareFileEndpoint + "Items($($Item.Id))/AccessControls?recursive=$Recursive")  -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function New-CitrixShareFileClientUser{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Account,
 
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

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    $body = @{
        Email = $EmailAddress
        FirstName= $FirstName
        LastName = $LastName
        Company = $Company
    } | ConvertTo-Json
    
    return Invoke-RestMethod -Method Post -Uri ($shareFileEndpoint + 'Users') -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Remove-CitrixShareFileAccessControl{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,

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

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Delete -Uri ($shareFileEndpoint + "AccessControls(principalid=$($User.Id),itemid=$($Item.Id))")  -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Remove-CitrixShareFileFolderTemplate{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Account,
 
        [Parameter(Mandatory = $false, Position=1)]
        [string]$Id,

        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    $headers = @{
        Authorization = "Bearer $Token"
    }

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    return Invoke-RestMethod -Method Delete -Uri ($shareFileEndpoint + "FolderTemplates($Id)") -ContentType "application/json" -Headers $headers -UseBasicParsing
}

function Send-CitrixShareFileUserWelcomeEmail{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Account,
 
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

    $shareFileEndpoint = "https://$Account.sf-api.com/sf/v3/"

    $body = @{
        CustomMessage = $Message
        NotifySender = $false
    } | ConvertTo-Json
    
    return Invoke-RestMethod -Method Post -Uri ($shareFileEndpoint + "Users($($User.Id))/WelcomeNotification") -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing
}
