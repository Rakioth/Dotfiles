. "$env:DOTFILES\core\main.ps1"

Register-ArgumentCompleter -CommandName dot -ScriptBlock {
    param($wordToComplete, $commandAst)

    $words       = $commandAst.ToString().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $suggestions = @()

    switch ($words.Count) {
        1 {
            $suggestions = Dot-ListContexts
        }
        2 {
            $context  = $words[1]
            $contexts = Dot-ListContexts

            if ($contexts -contains $context) {
                $suggestions = Dot-ListContextScripts -Context $context
            } else {
                $suggestions = $contexts
            }
        }
        3 {
            $context = $words[1]
            $script  = $words[2]
            $scripts = Dot-ListContextScripts -Context $context

            if ($scripts -notcontains $script) {
                $suggestions = $scripts
            }
        }
        default {
            $suggestions = @()
        }
    }

    if (-not $suggestions) {
        return $null
    }

    $suggestions | Where-Object { $_ -like "$wordToComplete*" }
}
