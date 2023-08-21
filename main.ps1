function Get-Load-Save {
    Get-Content load-saves.txt | ConvertFrom-Json
}

function Change-Save-File {
    Write-Output "Witch Games ?
        1. Assassin's Creed Unity
        2. Assassin's Creed Syndicate
    "

    $USER_GAME_CHOICE = Read-Host "Please enter your choice "
    Write-Output $USER_GAME_CHOICE
}

function Get-User-Choice {
    Write-Output "
        1. See loaded saves
        2. Change Save
    " 
    $USER_CHOICE = Read-Host "Please enter your choice "

    Write-Output $USER_CHOICE
}

Get-User-Choice