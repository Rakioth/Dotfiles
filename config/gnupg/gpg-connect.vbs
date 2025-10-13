CreateObject("WScript.Shell").Run("powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -Command 'gpg-connect-agent reloadagent /bye; Start-Sleep -Seconds 5;'"), 0
