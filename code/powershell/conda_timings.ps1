<#
$timer_base_conda = Measure-Command {
    If (Test-Path "C:\Users\Arthur\anaconda3\Scripts\conda.exe") {
        (& "C:\Users\Arthur\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
    }
}
Write-Host 'base conda loading time:' ([string] $timer_base_conda.TotalMilliseconds) 'ms'
#>

<#
$timer_fast_conda = Measure-Command {
    If (Test-Path "C:\Users\Arthur\anaconda3\Scripts\conda.exe") {
        # (& "C:\Users\Arthur\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
        . "C:\Users\Arthur\anaconda3\shell\condabin\conda-hook-fast.ps1"
    }
}
Write-Host 'fast conda loading time:' ([string] $timer_fast_conda.TotalMilliseconds) 'ms'
#>

function Mean {
    param ([array]$list)
    $total = 0
    foreach ($item in $list) {$total += $item}
    return ([decimal]($total) / [decimal]($list.Length))
}

$load_times = @()
for ($i = 0; $i -le 1000; ++$i) {
    $load_time = (Measure-Command { pwsh.exe -Command "exit" }).TotalMilliseconds
    Write-Output "try #$($i): $load_time"
    $load_times += $load_time
}
Write-Output "`nmean timing:"
Write-Output $(Mean $load_times)


# on powershell.exe (5.1.19041.3031), mean load time (1000 tries):

    # conda-less:
    # 107,48 ms

    # vanilla conda:
    # 561,95 ms

    # fast conda:
    # 500,98 ms

    # fast conda without "conda activate base":
    # 200,27 ms

# on pwsh.exe (7.3.5), mean load time (1000 tries):

    # conda-less:
    # 197,01 ms

    # vanilla conda:
    # 665,57 ms

    # fast conda:
    # 498,73 ms

    # fast conda without "conda activate base":
    # 297,07 ms
