# command
# Copy-Item "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\cc282584-0792-4295-8bd8-762958c54672\857" -Destination "D:\PERSO\GAMES\ACU_SaveFile\ACU\Sasha-Main" -Force -Recurse -Verbose

# PATH Var
$LOADED_SAVE = "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\cc282584-0792-4295-8bd8-762958c54672\"
$ACU_SAVE = "D:\PERSO\GAMES\ACU_SaveFile\ACU"
$ACS_SAVE = "D:\PERSO\GAMES\ACU_SaveFile\ACS"

$ACUSAVE_LIST = Get-ChildItem $ACU_SAVE | Select-Object -ExpandProperty "Name"
$ACSSAVE_LIST = Get-ChildItem $ACS_SAVE | Select-Object -ExpandProperty "Name"

#FUNCTION
function Backup-TheSave {
    if(Test-Path "$($LOADED_SAVE)857"){
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | Select-Object -ExpandProperty "ACU"
        Write-Output "Copy of the old AC Unity's Save $($SAVE_STOCK_NAME) to its directory..."
        $SAVE_STOCK_DIRECTORY = "$($ACU_SAVE)\$($SAVE_STOCK_NAME)"
        Copy-Item "$($LOADED_SAVE)857" -Destination $SAVE_STOCK_DIRECTORY -Force -Recurse
        Write-Output "Done"
    }
    if(Test-Path "$($LOADED_SAVE)1875"){
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | Select-Object -ExpandProperty "ACS"
        Write-Output "Copy of the old AC Syndicat's Save $($SAVE_STOCK_NAME) to its directory..."
        $SAVE_STOCK_DIRECTORY = "$($ACS_SAVE)\$($SAVE_STOCK_NAME)"
        Copy-Item "$($LOADED_SAVE)1875" -Destination $SAVE_STOCK_DIRECTORY -Force -Recurse 
        Write-Output "Done"
    }
}

function Get-LoadSave {
    Get-Content load-saves.txt | ConvertFrom-Json
    Start-Sleep -Seconds 0.6
    Get-UserChoice
}

function Edit-SaveFile {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {         
        Write-Output $ACUSAVE_LIST
        $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to play "
        if($USER_SAVE_CHOICE -eq "none")
        {
            Get-UserChoice
        }
        $SAVE_EXPORT_NAME = ($ACUSAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
        $SAVE_EXPORT_DIRECTORY = "$($ACU_SAVE)\$($SAVE_EXPORT_NAME)\857"
        
        Write-Output "Changing save file..."
        Copy-Item $SAVE_EXPORT_DIRECTORY -Destination $LOADED_SAVE -Force -Recurse
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | Select-Object -ExpandProperty "ACU"
        (Get-Content .\load-saves.txt).Replace($SAVE_STOCK_NAME, $SAVE_EXPORT_NAME) | Set-Content .\load-saves.txt
        Write-Output "Done"
        Get-UserChoice
    }elseif($USER_GAME_CHOICE -eq 2)
    {
        Write-Output $ACSSAVE_LIST
        $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to play "
        if($USER_SAVE_CHOICE -eq "none")
        {
            Get-UserChoice
        }
        $SAVE_EXPORT_NAME = ($ACSSAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
        $SAVE_EXPORT_DIRECTORY = "$($ACS_SAVE)\$($SAVE_EXPORT_NAME)\1875"

        Write-Output "Changing save file..."
        Copy-Item $SAVE_EXPORT_DIRECTORY -Destination $LOADED_SAVE -Force -Recurse
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | Select-Object -ExpandProperty "ACS"
        (Get-Content .\load-saves.txt).Replace($SAVE_STOCK_NAME, $SAVE_EXPORT_NAME) | Set-Content .\load-saves.txt
        Write-Output "Done"
        Get-UserChoice
    }elseif($USER_GAME_CHOICE -eq 3)
    {
        Get-UserChoice
    }else
    {
        Write-Output "please enter your choice between the choice"
        Edit-SaveFile
    }
}

function New-SaveFile {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | Select-Object -ExpandProperty "ACU"
        $USER_SAVE_NAME_CHOICE = Read-Host "Please name your new save "
        Write-Output "Deleting loaded AC Unity save"
        Remove-Item -Force -Recurse "$($LOADED_SAVE)\857"
        (Get-Content .\load-saves.txt).Replace($SAVE_STOCK_NAME, $USER_SAVE_NAME_CHOICE) | Set-Content .\load-saves.txt
        New-Item -ItemType Directory -Path $ACU_SAVE\$USER_SAVE_NAME_CHOICE 
        Write-Output "Done"
        Get-UserChoice

    }elseif($USER_GAME_CHOICE -eq 2)
    {
        $SAVE_STOCK_NAME = Get-Content load-saves.txt | ConvertFrom-Json | Select-Object -ExpandProperty "ACS"
        $USER_SAVE_NAME_CHOICE = Read-Host "Please name your new save "
        Write-Output "Deleting loaded AC Syndicate save"
        Remove-Item -Force -Recurse "$($LOADED_SAVE)\1875"
        (Get-Content .\load-saves.txt).Replace($SAVE_STOCK_NAME, $USER_SAVE_NAME_CHOICE) | Set-Content .\load-saves.txt
        New-Item -ItemType Directory -Path $ACS_SAVE\$USER_SAVE_NAME_CHOICE
        Write-Output "Done"
        Get-UserChoice
    }elseif($USER_GAME_CHOICE -eq 3)
    {
        Get-UserChoice
    }
}

function Remove-SaveFile {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    if($USER_GAME_CHOICE -eq 1)
    {         
        Write-Output $ACUSAVE_LIST
        $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to delete "
        if($USER_SAVE_CHOICE -eq "none")
        {
            Get-UserChoice
        }
        $SAVE_EXPORT_NAME = ($ACUSAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
        $SAVE_EXPORT_DIRECTORY = "$($ACU_SAVE)\$($SAVE_EXPORT_NAME)"
        
        Write-Output "Deleting save file..."
        Remove-Item -Force -Recurse $SAVE_EXPORT_DIRECTORY
        Write-Output "Done"
        Get-UserChoice
    }elseif($USER_GAME_CHOICE -eq 2)
    {
        Write-Output $ACSSAVE_LIST
        $USER_SAVE_CHOICE = Read-Host "Please choose the Save you want to delete "
        if($USER_SAVE_CHOICE -eq "none")
        {
            Get-UserChoice
        }
        $SAVE_EXPORT_NAME = ($ACSSAVE_LIST -split '\r?\n')[$USER_SAVE_CHOICE -1]
        $SAVE_EXPORT_DIRECTORY = "$($ACS_SAVE)\$($SAVE_EXPORT_NAME)"

        Write-Output "Deleting save file..."
        Remove-Item -Force -Recurse $SAVE_EXPORT_DIRECTORY
        Write-Output "Done"
        Get-UserChoice
    }elseif($USER_GAME_CHOICE -eq 3)
    {
        Get-UserChoice
    }else
    {
        Write-Output "please enter your choice between the choice"
        Remove-SaveFile
    }
}

function Run-ACGames {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
        3. Back to menu.
    "
    $USER_GAME_CHOICE = Read-Host "Please enter your choice "

    if ($USER_GAME_CHOICE -eq 1) {
        write-output "Executing Assassin's Creed Unity..."
    } elseif ($USER_GAME_CHOICE -eq 2) {
        write-output "Executing Assassin's Creed Syndicate..."
    } elseif ($USER_GAME_CHOICE -eq 3) {
        Get-UserChoice
    } else {
        Write-Output "please enter your choice between the choice"
        Run-ACGames
    }
}
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
        Edit-SaveFile
    }elseif($USER_CHOICE -eq 3)
    {
        New-SaveFile
    }elseif($USER_CHOICE -eq 4)
    {
        Remove-SaveFile
    }elseif($USER_CHOICE -eq 5)
    {
        Run-ACGames
    }elseif($USER_CHOICE -eq 6)
    {
        Backup-TheSave
        exit
    }else
    {
        Write-Output "please enter your choice between 1 or 2 "
        Get-UserChoice
    }
}

Backup-TheSave
Get-UserChoice