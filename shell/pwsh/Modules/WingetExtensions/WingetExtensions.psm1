. "$env:DOTFILES\package\winget\clean.ps1"
. "$env:DOTFILES\package\winget\search.ps1"
. "$env:DOTFILES\package\winget\update.ps1"

function winget {
    switch ($args[0]) {
        "clean" {
            Winget-Clean
        }
        "search" {
            Winget-Search -Query $args[1]
        }
        "update" {
            Winget-Update
        }
        default {
            winget.exe $args
        }
    }
}
