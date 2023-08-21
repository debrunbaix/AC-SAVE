# command
# Copy-Item "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\cc282584-0792-4295-8bd8-762958c54672\857" -Destination "D:\PERSO\GAMES\ACU_SaveFile\ACU\Sasha-Main" -Force -Recurse -Verbose

# PATH Var
$LOADED_SAVE = "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\cc282584-0792-4295-8bd8-762958c54672\"
$ACU_SAVE = "D:\PERSO\GAMES\ACU_SaveFile\ACU"
$ACS_SAVE = "D:\PERSO\GAMES\ACU_SaveFile\ACS"

$ACUSAVE_LIST = dir $ACU_SAVE | select -ExpandProperty "Name"
$ACSSAVE_LIST = dir $ACS_SAVE | select -ExpandProperty "Name"

#FUNCTION
function Save-The-Save {
    $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | select -ExpandProperty "ACU"
    Write-Output "Copy of the old AC Unity's Save $($SAVE_STOCK_NAME) to its directory..."
    $SAVE_STOCK_DIRECTORY = "$($ACU_SAVE)\$($SAVE_STOCK_NAME)"
    Copy-Item "$($LOADED_SAVE)857" -Destination $SAVE_STOCK_DIRECTORY -Force -Recurse

    $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | select -ExpandProperty "ACS"
    Write-Output "Copy of the old AC Syndicat's Save $($SAVE_STOCK_NAME) to its directory..."
    $SAVE_STOCK_DIRECTORY = "$($ACS_SAVE)\$($SAVE_STOCK_NAME)"
    Copy-Item "$($LOADED_SAVE)1875" -Destination $SAVE_STOCK_DIRECTORY -Force -Recurse 
}

function Get-Load-Save {
    Get-Content load-saves.txt | ConvertFrom-Json
}

function Change-Save-File {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {         
        Write-Output $ACUSAVE_LIST
        $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to play "
        $SAVE_EXPORT_NAME = ($ACUSAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
        $SAVE_EXPORT_DIRECTORY = "$($ACU_SAVE)\$($SAVE_EXPORT_NAME)\857"
        
        Write-Output "Changing save file..."
        Copy-Item $SAVE_EXPORT_DIRECTORY -Destination $LOADED_SAVE -Force -Recurse
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | select -ExpandProperty "ACU"
        (Get-Content .\load-saves.txt).Replace($SAVE_STOCK_NAME, $SAVE_EXPORT_NAME) | Set-Content .\load-saves.txt
    }elseif($USER_GAME_CHOICE -eq 2)
    {
        Write-Output $ACSSAVE_LIST
        $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to play "
        $SAVE_EXPORT_NAME = ($ACSSAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
        $SAVE_EXPORT_DIRECTORY = "$($ACS_SAVE)\$($SAVE_EXPORT_NAME)\1875"

        Write-Output "Changing save file..."
        Copy-Item $SAVE_EXPORT_DIRECTORY -Destination $LOADED_SAVE -Force -Recurse
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | select -ExpandProperty "ACS"
        (Get-Content .\load-saves.txt).Replace($SAVE_STOCK_NAME, $SAVE_EXPORT_NAME) | Set-Content .\load-saves.txt
    }
}

function Create-Save-File {
    Write-Output "To Do"
}

function Get-User-Choice {
    Write-Output "
        1. See loaded saves
        2. Change Save
        3. Create New Save
    " 
    $USER_CHOICE = Read-Host "Please enter your choice "

    if($USER_CHOICE -eq 1)
    {
        Write-Output "choice 1"
        Get-Load-Save
    }elseif($USER_CHOICE -eq 2)
    {
        Write-Output "choice 2"
        Change-Save-File
    }elseif($USER_CHOICE -eq 3)
    {
        Write-Output "choice 3"
    }else
    {
        Write-Output "please enter your choice between 1 or 2 "
        Get-User-Choice
    }
}

Save-The-Save
Get-User-Choice