# oh-my-posh-themes

Custom Oh My Posh theme. The preset `lePauloRicardo.omp.json` is built by remixing several official themes from JanDeDobbeleer’s repo ([oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh/)) and tuned for a fast, colorful, and Git-friendly prompt.

## Highlights
- Powerline styling with contrasting colors for root indicator, OS/WSL, time, and path.
- Full Git block: upstream icon, ahead/behind, staging/working, stash count, and dynamic colors based on repo status.
- Execution time for slow commands plus a clear final status (ok/error).
- Optional second line showing versions of Java, Node, Python, Kotlin, Go, Rust, and .NET for polyglot stacks.
- Included PowerShell profile (`Microsoft.PowerShell_profile.ps1`) caches the Oh My Posh init to speed up shell startup.

## Prerequisites
- [Oh My Posh](https://github.com/JanDeDobbeleer/oh-my-posh) installed (e.g., `winget install JanDeDobbeleer.OhMyPosh -s winget`).
- A Nerd Font set in your terminal so all icons render correctly.

## How to use the theme
1. Copy `lePauloRicardo.omp.json` to your themes folder (e.g., `%UserProfile%\.poshthemes`).
2. Add to your PowerShell profile:
   ```powershell
   oh-my-posh init pwsh --config "$env:UserProfile\.poshthemes\lePauloRicardo.omp.json" | Invoke-Expression
   ```
3. Open a new terminal and verify icons/colors look correct.

## Using the included profile
If you want the same optimized behavior, use `Microsoft.PowerShell_profile.ps1` as a base. It:
- Sets UTF-8 encoding and handy aliases.
- Lazy-loads posh-git.
- Caches `oh-my-posh init` when the theme changes to improve startup.

## Files
- `lePauloRicardo.omp.json` – main theme.
- `Microsoft.PowerShell_profile.ps1` – sample profile with Oh My Posh cache and shortcuts.
- `LICENSE` – MIT license for the theme/profile.
