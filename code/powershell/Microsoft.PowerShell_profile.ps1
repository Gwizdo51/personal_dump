function Write-BranchName {
    if ($branch -eq "HEAD") {
        # we're probably in detached HEAD state, so print the SHA
        $branch = git rev-parse --short HEAD
        Write-Host " ($branch)" -ForegroundColor "red"
    }
    else {
        # we're on an actual branch, so print it
        Write-Host " ($branch)" -ForegroundColor "blue"
    }
}

function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    $branch = git rev-parse --abbrev-ref HEAD
    if (!!$branch) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-BranchName
    }
    else {
        # no branch
        Write-Host $path -ForegroundColor "green"
    }

    return $userPrompt
}

function cda {conda activate workenv}

function cdd {conda deactivate}

$code = "D:\Code\"

# alias git_tree='git log --graph --decorate --pretty=oneline --abbrev-commit'
function git_tree {git log --graph --decorate --pretty=oneline --abbrev-commit}
function git_ps {git submodules update --init --recursive}
function git_us {git submodules update --init --recursive --remote}
function gfs {git fetch; git status}

function conda_prompt {
    & "$HOME\anaconda3\shell\condabin\conda-hook.ps1"
    conda activate base
}
conda_prompt

function rmd {rm -r $args[0]}
function la {dir -Force}

function find {Get-ChildItem -Recurse -Filter $args[0]}

function path {echo $Env:path.replace(";", "`n")}
