# oh-my-posh --init --shell pwsh --config ~/scoop/apps/oh-my-posh/current/themes/pure.omp.json | Invoke-Expression

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
}
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -Colors @{ InlinePrediction = "$([char]0x1b)[38;5;238m"}
Set-PSReadLineOption -Colors @{ InlinePrediction = '#63A4ff' }

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
    Write-Output "Executing Conda base environment update"
    sudo conda update --update-all
    # Write-Output "Executing Conda Damn environment update"
    # conda activate Damn
    # sudo conda update --update-all
    # Write-Output "Leaving Conda Damn environment"
    # conda deactivate
    rustup update
    # npm update -g
    # mpm --verbose --package-level=complete --upgrade
    mpm --update --verbose
    dotnet tool update bbdown --global
}

function clean_shits {
    Write-Host "Clearing scoop old versions and caches" -ForegroundColor Cyan -BackgroundColor Yellow
    scoop cleanup *
    scoop cache rm *
    Write-Host "Clearing chocolatey caches" -ForegroundColor Cyan -BackgroundColor Yellow
    sudo choco-cleaner.ps1
    Write-Host "Clearing conda caches" -ForegroundColor Cyan -BackgroundColor Yellow
    sudo conda clean --all
    sudo conda clean --force-pkgs-dirs
    Write-Host "Removing Gradle package, wrapper, download intermediate caches" -ForegroundColor Blue
    Remove-Item -fo -r ~\.gradle\caches\*
    Remove-Item -fo -r ~\.gradle\wrapper\*
    Remove-Item -fo -r ~\.gradle\.tmp\*
    Write-Host "Removing Maven caches" -ForegroundColor Cyan -BackgroundColor Yellow
    Remove-Item -fo -r ~\.m2\repository\*
    Write-Host "Removing NuGet caches" -ForegroundColor Cyan -BackgroundColor Yellow
    Remove-Item -fo -r ~\.nuget\
    Write-Host "Clearing Cargo caches" -ForegroundColor Cyan -BackgroundColor Yellow
    cargo cache --autoclean
}

function call_git_pull_every_subfolder {
    Get-ChildItem -Directory | ForEach-Object { 
        Write-Host "...::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::..." -ForegroundColor Yellow
        Write-Host "Getting latest for $_ " -ForegroundColor DarkGreen | git -C $_.FullName pull --all --recurse-submodules --verbose 
    }
}

function call_git_reset_every_subfolder {
    Get-ChildItem -Directory | ForEach-Object {
        Write-Host "...::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::==::~~::..." -ForegroundColor Yellow
        Write-Host "Resetting for $_" -ForegroundColor DarkCyan | git -C $_.FullName reset --hard
    }
}

function git_conf_eterocell {
    git config --global user.name "Eterocell"
    git config --global user.email "eterocell@outlook.com"
    git config --global user.signingkey D668181C9DFCEDC5
    git config --global commit.gpgsign true
}

function git_conf_geetest {
    git config --global user.name "chenruixiao"
    git config --global user.email "chenruixiao@geetest.com"
    git config --global user.signingkey 180805E2B066DCA5
    git config --global commit.gpgsign true
}

Invoke-Expression (&starship init powershell)

function get_folder_with_size {
    param ($Path = ".")

    $PrettySizeColumn = @{name = "Size"; expression = {
            $size = $_.Size
            if ( $size -lt 1KB ) { $sizeOutput = "$("{0:N2}" -f $size) B" }
            ElseIf ( $size -lt 1MB ) { $sizeOutput = "$("{0:N2}" -f ($size / 1KB)) KB" }
            ElseIf ( $size -lt 1GB ) { $sizeOutput = "$("{0:N2}" -f ($size / 1MB)) MB" }
            ElseIf ( $size -lt 1TB ) { $sizeOutput = "$("{0:N2}" -f ($size / 1GB)) GB" }
            ElseIf ( $size -lt 1PB ) { $sizeOutput = "$("{0:N2}" -f ($size / 1TB)) TB" }
            ElseIf ( $size -ge 1PB ) { $sizeOutput = "$("{0:N2}" -f ($size / 1PB)) PB" } 
            $sizeOutput
        }
    }

    Get-ChildItem -Path $Path | Where-Object { $_.PSIsContainer } | ForEach-Object { 
        $size = ( Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer } | Measure-Object -Sum Length).Sum 
        $obj = new-object -TypeName psobject -Property @{
            Path = $_.Name
            Time = $_.LastWriteTime
            Size = $size
        }
        $obj  
    } | Sort-Object -Property Size -Descending | Select-Object Path, Time, $PrettySizeColumn
}

function get_large_files {
    Get-ChildItem -File | Where-Object {$_.Length -gt 52428800} | Select-Object Name, CreationTime,Length 
}
