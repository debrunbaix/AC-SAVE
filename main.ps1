# saves path
$LOADED_SAVE = (Get-Content .\config.json | ConvertFrom-Json).LOADED_SAVE
$ACU_SAVE = (Get-Content .\config.json | ConvertFrom-Json).ACU_SAVE
$ACS_SAVE = (Get-Content .\config.json | ConvertFrom-Json).ACS_SAVE

# list of AC saves in backup
$ACUSAVE_LIST = Get-ChildItem $ACU_SAVE | Select-Object -ExpandProperty "Name"
$ACSSAVE_LIST = Get-ChildItem $ACS_SAVE | Select-Object -ExpandProperty "Name"

# AC Game binary
$ACU_EXE = (Get-Content .\config.json | ConvertFrom-Json).ACU_EXE
$ACS_EXE = (Get-Content .\config.json | ConvertFrom-Json).ACS_EXE

#
# copy the loaded game to the backup path
#
function Backup-TheSave {
    param (
        $GAME,
        $GAME_SAVE,
        $SAVE_FILE_NUMBER
    )
    $SAVE_STOCK_NAME = Get-Content load-saves.json | ConvertFrom-Json | Select-Object -ExpandProperty $GAME
    Write-Output "Copy of the old $($GAME) Save $($SAVE_STOCK_NAME) to its directory..."
    $SAVE_STOCK_DIRECTORY = "$($GAME_SAVE)\$($SAVE_STOCK_NAME)"
    Copy-Item "$($LOADED_SAVE)$($SAVE_FILE_NUMBER)" -Destination $SAVE_STOCK_DIRECTORY -Force -Recurse
    Write-Output "Done"
}

#
# 1. User choice what saves to load on the game
# 2. get the path of the save choice by user
# 3. copy the content of this path to the save game
# 4. replace the save name in the "load-saves.json" file
#
function Edit-SaveFile {
    param (
        $GAME_SAVE_LIST,
        $GAME_SAVE_DIRECTORY,
        $SAVE_FILE_NUMBER,
        $GAME_NAME
    )
    Write-Output $ACUSAVE_LIST
    $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to play "
    if($USER_SAVE_CHOICE -eq "none")
    {
        Get-UserChoice
    }
    $SAVE_EXPORT_NAME = ($GAME_SAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
    $SAVE_EXPORT_DIRECTORY = "$($GAME_SAVE_DIRECTORY)\$($SAVE_EXPORT_NAME)\$($SAVE_FILE_NUMBER)"
        
    Write-Output "Changing save file..."
    Copy-Item $SAVE_EXPORT_DIRECTORY -Destination $LOADED_SAVE -Force -Recurse
    $SAVE_STOCK_NAME = Get-Content load-saves.json | ConvertFrom-Json | Select-Object -ExpandProperty $GAME_NAME
    (Get-Content .\load-saves.json).Replace($SAVE_STOCK_NAME, $SAVE_EXPORT_NAME) | Set-Content .\load-saves.json
    Write-Output "Done"
    Get-UserChoice
}

#
# 1. get the loaded save's name
# 2. remove it
# 3. user write the new save name
# 4. it replace the last save in the "load-saves.json" file
# 5. create new save path
#
function New-SaveFile {
    param(
        $GAME_NAME,
        $GAME_FILE_NUMBER,
        $GAME_SAVE_DIRECTORY
    )
    $SAVE_STOCK_NAME = Get-Content load-saves.json | ConvertFrom-Json | Select-Object -ExpandProperty "ACU"
    $USER_SAVE_NAME_CHOICE = Read-Host "Please name your new save "
    Write-Output "Deleting loaded $($GAME_NAME) save"
    Remove-Item -Force -Recurse "$($LOADED_SAVE)\$($GAME_FILE_NUMBER)"
    (Get-Content .\load-saves.json).Replace($SAVE_STOCK_NAME, $USER_SAVE_NAME_CHOICE) | Set-Content .\load-saves.json
    New-Item -ItemType Directory -Path $ACU_SAVE\$USER_SAVE_NAME_CHOICE 
    Write-Output "Done"
    Get-UserChoice
}

#
# 1. User choice what saves to delete
# 2. remove the user choice
#
function Remove-SaveFile {
    param (
        $GAME_SAVE_LIST,
        $GAME_SAVE_DIRECTORY
    )
    Write-Output $GAME_SAVE_LIST
    $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to delete "
    if($USER_SAVE_CHOICE -eq "none")
    {
        Get-UserChoice
    }
    $SAVE_EXPORT_NAME = ($GAME_SAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
    $SAVE_EXPORT_DIRECTORY = "$($GAME_SAVE_DIRECTORY)\$($SAVE_EXPORT_NAME)"
        
    Write-Output "Deleting save file..."
    Remove-Item -Force -Recurse $SAVE_EXPORT_DIRECTORY
    Write-Output "Done"
    Get-UserChoice
}

#
# 1. if a save is loaded in the game's path
# 2. execute backup-theSave 
# 
function Initialize-The-Backup {
    if(Test-Path "$($LOADED_SAVE)857"){
        Backup-TheSave "ACU" $ACU_SAVE 857
    }
    if(Test-Path "$($LOADED_SAVE)1875"){
        Backup-TheSave "ACS" $ACS_SAVE 1875
    }
}


#
# 1. this function display what saves are in game
# 2. re-execute init choices function 
#
function Get-LoadSave {
    Get-Content load-saves.json | ConvertFrom-Json
    Start-Sleep -Seconds 0.6
    Get-UserChoice
}

#
# 1. Function to init the savefile transfert
# 2. User can choice between ACU & ACS or to re-execute Init choice Function
# 3. Execute the transfert with args : 
#       - the game's saves list
#       - path of the loaded save
#       - the ID of the game
#       - the game's name
#
function Initialize-Modify-SaveFile {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {         
        Edit-SaveFile $ACUSAVE_LIST $ACU_SAVE "857" "ACU"
    }elseif($USER_GAME_CHOICE -eq 2)
    {
        Edit-SaveFile $ACSSAVE_LIST $ACS_SAVE "1875" "ACS"
    }elseif($USER_GAME_CHOICE -eq 3)
    {
        Get-UserChoice
    }else
    {
        Write-Output "please enter your choice between the choice"
        Initialize-Modify-SaveFile
    }
}

#
# 1. User choice between ACU & ACS to create new save file
# 2. execute the function to create new save with for args :
#       - game's name
#       - game's ID
#       - game's save path
#
function Initialize-New-SaveFile {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {
        New-SaveFile "ACU" "857" $ACU_SAVE
    }elseif($USER_GAME_CHOICE -eq 2)
    {
        New-SaveFile "ACS" "1875" $ACS_SAVE
    }elseif($USER_GAME_CHOICE -eq 3)
    {
        Get-UserChoice
    }
}

#
# 1. user choice in what game to remove save file
# 2. Execute the remove save file function
#
function Initialize-Remove-SaveFile {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {         
        Remove-SaveFile $ACUSAVE_LIST $ACU_SAVE
    }elseif($USER_GAME_CHOICE -eq 2)
    {
        Remove-SaveFile $ACSSAVE_LIST $ACS_SAVE
    }elseif($USER_GAME_CHOICE -eq 3)
    {
        Get-UserChoice
    }else
    {
        Write-Output "please enter your choice between the choice"
        Initialize-Remove-SaveFile
    }
}

#
# 1. function to execute one of the AC games
#
function Start-ACGames {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "

    if ($USER_GAME_CHOICE -eq 1) {
        write-output "Executing Assassin's Creed Unity..."
        & $ACU_EXE
    } elseif ($USER_GAME_CHOICE -eq 2) {
        write-output "Executing Assassin's Creed Syndicate..."
        & $ACS_EXE
    } elseif ($USER_GAME_CHOICE -eq 3) {
        Get-UserChoice
    } else {
        Write-Output "please enter your choice between the choice"
        Start-ACGames
    }
}

# 
# Init Function to choice what the user want.
#
function Get-UserChoice {
    Write-Output "
        1. See loaded saves
        2. Change Save
        3. Create New Save
        4. Delete Save
        5. Launch games
        6. Exit

    " 
    $USER_CHOICE = Read-Host "Please enter your choice "

    if($USER_CHOICE -eq  1)
    {
        Get-LoadSave
    }elseif($USER_CHOICE -eq 2)
    {
        Initialize-Modify-SaveFile
    }elseif($USER_CHOICE -eq 3)
    {
        Initialize-New-SaveFile
    }elseif($USER_CHOICE -eq 4)
    {
        Initialize-Remove-SaveFile
    }elseif($USER_CHOICE -eq 5)
    {
        Start-ACGames
    }elseif($USER_CHOICE -eq 6)
    {
        Initialize-The-Backup
        exit
    }else
    {
        Write-Output "please enter your choice between 1 or 2 "
        Get-UserChoice
    }
}

# backup loaded file before execute the user choice
Initialize-The-Backup
Get-UserChoice
