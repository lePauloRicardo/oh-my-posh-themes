# =============================================================================
# OPTIMIZED POWERSHELL PROFILE
# =============================================================================

# -----------------------------------------------------------------------------
# 1. PERFORMANCE & ENCODING
# -----------------------------------------------------------------------------
$env:PYTHONIOENCODING = "utf-8"
$env:PYTHONUTF8 = "1"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# -----------------------------------------------------------------------------
# 2. GIT AUTOCOMPLETE (Lazy Load)
# -----------------------------------------------------------------------------
$global:GitPromptLoaded = $false
function Load-PoshGit
{
    if (-not $global:GitPromptLoaded)
    {
        Import-Module posh-git -ErrorAction SilentlyContinue
        $global:GitPromptLoaded = $true
    }
}

# Trigger posh-git only when needed (optional: auto-load in git repos)
Register-ArgumentCompleter -CommandName git -ScriptBlock {
    Load-PoshGit
}

# -----------------------------------------------------------------------------
# 3. OH MY POSH (Cached for Speed) - INTERACTIVE ONLY
# -----------------------------------------------------------------------------
# We wrap this in a check so it NEVER runs on the agent, avoiding the Null error.
if ($Host.Name -eq 'ConsoleHost' -and -not [System.Console]::IsOutputRedirected)
{
    $themePath = "<path to themes>\lePauloRicardo.omp.json"
    $ompCache = "$env:TEMP\omp_init.ps1"

    # Regenerate cache if theme changed or cache doesn't exist
    if (-not (Test-Path $ompCache) -or ((Get-Item $themePath -ErrorAction SilentlyContinue).LastWriteTime -gt (Get-Item $ompCache).LastWriteTime))
    {

        if (Test-Path $themePath)
        {
            oh-my-posh init pwsh --config $themePath | Out-File $ompCache -Encoding UTF8
        }
        else
        {
            oh-my-posh init pwsh | Out-File $ompCache -Encoding UTF8
        }
    }

    # Load from cache
    . $ompCache
}

# -----------------------------------------------------------------------------
# 4. THEFUCK (Lazy Load)
# -----------------------------------------------------------------------------
function dass
{
    thefuck --alias dass | Out-String | Invoke-Expression
    dass @args
}

# -----------------------------------------------------------------------------
# 5. PSREADLINE (History & Navigation) - INTERACTIVE ONLY
# -----------------------------------------------------------------------------
if ($Host.Name -eq 'ConsoleHost' -and -not [System.Console]::IsOutputRedirected)
{
    try
    {
        $PSReadLineOptions = @{
            PredictionSource = 'History'
            PredictionViewStyle = 'InlineView'
            HistorySearchCursorMovesToEnd = $true
        }
        Set-PSReadLineOption @PSReadLineOptions -ErrorAction Stop

        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
        Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
        Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
        Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord
    }
    catch
    {
        # Silently fail if the host refuses PSReadLine (common in some remote shells)
    }
}

# -----------------------------------------------------------------------------
# 6. USEFUL ALIASES & FUNCTIONS
# -----------------------------------------------------------------------------
# Quick navigation
function .. { Set-Location .. }
function ... {
Set-Location ..\..
}
function .... {
Set-Location ..\..\..
}

# Directory listing improvements
function ll
{
    Get-ChildItem -Force @args
}
function la
{
    Get-ChildItem -Force -Hidden @args
}

# Git shortcuts (will auto-load posh-git on first use)
function gs
{
    Load-PoshGit; git status @args
}
function ga
{
    Load-PoshGit; git add @args
}
function gc
{
    Load-PoshGit; git commit @args
}
function gp
{
    Load-PoshGit; git push @args
}
function gl
{
    Load-PoshGit; git log --oneline --graph --decorate @args
}

# Quick editor access (change 'code' to your preferred editor)
function e
{
    code @args
}

# Find file by name
function ff
{
    param([string]$name)
    Get-ChildItem -Recurse -Filter "*$name*" -ErrorAction SilentlyContinue
}

# Quick profile reload
function Reload-Profile
{
    . $PROFILE
    Write-Host "Profile reloaded!" -ForegroundColor Green
}
# Remove existing rp alias if it exists and is read-only
if (Test-Path Alias:rp)
{
    Remove-Item Alias:rp -Force -ErrorAction SilentlyContinue
}
Set-Alias rp Reload-Profile -ErrorAction SilentlyContinue



# -----------------------------------------------------------------------------
# 7. PERFORMANCE MEASUREMENT (Optional - Comment out after optimization)
# -----------------------------------------------------------------------------
# Uncomment below to see load time breakdown:
# Write-Host "Profile loaded in $((Get-History -Count 1).Duration.TotalMilliseconds)ms" -ForegroundColor Cyan
