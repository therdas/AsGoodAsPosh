function Show-List {
	Get-ChildItem | Format-Wide -Column 5
}

function Write-BranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD
        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host (" $branch " + [char]0xE0B1)  -NoNewLine -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            
	    if(git status --porcelain |Where {$_ -match '^\?\?'}){
    		Write-Host (" $branch " + [char]0xE0B1) -NoNewLine -ForegroundColor "red"
	    } 
	    elseif(git status --porcelain |Where {$_ -notmatch '^\?\?'}) {
    		Write-Host (" $branch " + [char]0xE0B1) -NoNewLine -ForegroundColor "yellow"
	    }
	    else {
    		Write-Host (" $branch " + [char]0xE0B1) -NoNewLine -ForegroundColor "blue"
	    }
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host (" No Branch " + [char]0xE0B1) -NoNewLine -ForegroundColor "yellow"
    }
}

function prompt {
	$p = Split-Path -leaf -path (Get-Location)

	Write-Host (" REPLACE WITH YOUR NAME") -NoNewLine `
     -BackgroundColor 1 `
     -ForegroundColor black

	Write-Host ([char]0x2588 + [char]0xE0B0) -NoNewLine -ForegroundColor 1 -BackgroundColor 2

    Write-Host ( " " + $p ) -NoNewLine `
     -BackgroundColor 2 `
     -ForegroundColor black

Write-Host ([char]0x2588 + [char]0xE0B0) -NoNewLine -ForegroundColor 2

	if (Test-Path .git) {
		Write-BranchName
	}

    return " "
}

Set-Alias -Name lst -Value Show-List
