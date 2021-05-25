Invoke-Expression (oh-my-posh --init --shell pwsh --config ~\scoop\apps\oh-my-posh\current\themes\pure.omp.json)

function use_clash {
    $Env:http_proxy = "http://127.0.0.1:7890"; $Env:https_proxy = "http://127.0.0.1:7890"
}

function use_nexitally {
    $Env:http_proxy = "http://127.0.0.1:1081"; $Env:https_proxy = "http://127.0.0.1:1081"
}

function no_proxy {
    $Env:http_proxy = ""; $Env:https_proxy = ""
}

function routine_upgrade {
    sudo scoop update *
    sudo choco upgrade all
    sudo conda update --update-all
    rustup update
    # npm update -g
    # conda clean --all
    # mpm --verbose --package-level=complete --upgrade
    mpm --update --verbose
}

function clean_shits {
    conda clean --all
    conda clean --force-pkgs-dirs
    Remove-Item -fo -r ~\.gradle\caches\*
    Remove-Item -fo -r ~\.m2\repository\*
}

function call_git_pull_every_subfolder {
    Get-ChildItem -Directory | ForEach-Object { 
        Write-Host "...::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::..." -ForegroundColor  Yellow
        Write-Host "Getting latest for $_ " -ForegroundColor DarkGreen | git -C $_.FullName pull --all --recurse-submodules --verbose 
    }
}
