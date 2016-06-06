# Place the lines:
# in your Profile before running this script
function AddAndCommit-Git {
  param (
    [string]$commitMessage
  )
  git ad
  git cm $commitMessage
  git st
  git log -1
}

function Get-PrettyLog {
  param (
    [int]$length
  )
    if ($length -eq 0) {
      $length = 5
    }

    git log -$length --pretty=format:'%C(yellow)%h %Cred%ad %C(yellow)%an%Cgreen%d %Creset%s' --date=short
}

function gitvimlog {
    git log -10 --pretty=format:'%h %ad %an %d %s' --date=short
}

function Get-SpecificBlame {
    param (
        $file,
        $hash,
        $startLine,
        $numberOfLines
    )
    
    g blame -c -L "$startLine,+$numberOfLines" "$hash^" -- $file
}

function Get-PrettyLogForFile {
    param (
        [string]$file
    )

    g log --follow --pretty=format:'%C(yellow)%h %Cred%ad %C(yellow)%an%Cgreen%d %Creset%s' --date=short $file
}

Function Delete-AllUntracked {
    git status --porcelain | where { $_.StartsWith("??") } | foreach-object { del $_.replace("?? ", "") }
}

Function Unstage-AllDeleted {
    git status --porcelain | where { $_.StartsWith(" D") } | foreach-object { git reset HEAD $_.replace(" D ", "") }
}

Function Save-Work {
    git stash save -u
}

Function Get-Work {
    git stash apply
}

Set-Alias g git
Set-Alias acg AddAndCommit-Git
Set-Alias log Get-PrettyLog
Set-Alias glogfile Get-PrettyLogForFile

function Echo-GitCommands {
  Write-Title "Git commands:"

  Write-Host "g st, g ad, g cm `"msg`"                  | git status, stage everything, commit with msg"
  Write-Host "acg `"msg`"                               | add and commit with msg"
  Write-Host "Create-Github x                         | create a repo on github called x, make it the remote origin and push to it"
  Write-Host "git pull --rebase origin master         | pull master and rebase my changes on top of them"
  Write-Host "git push -u origin master               | push master branch up to github"
  Write-Host "git checkout -b x                       | create a new branch x and move to it"
  Write-Host "git checkout --track origin/x           | create a local branch tracking a remote branch x"
  Write-Host "g push origin --delete b                | delete remote branch b"
  Write-Host "git remote set-url origin https://github.com/USERNAME/OTHERREPOSITORY.git | changing remote url"
  Write-Host "g checkout -- x                         | undo unstaged changes to file x"
  Write-Host "log x                                   | Get-PrettyLog x - show pretty oneline git log x defaults to 5"
  Write-Host "git reset HEAD x                        | undo staged changes to file x"
  Write-Host "git config branch.x.rebase true         | set branch x to pull rebase by default"
  Write-Host "g diff --stat origin/x                  | see what you are about to push to remote branch x"
  Write-Host "g diff --cached x                       | see what's changed in a staged file x"
  Write-Host "g stash pop `"stash@{1}`"                  | unstash a specific stash (noticed quoted stash index for windows)"
  Write-Host "rebase workflow: ends up with clean linear history even when events happened in parallel"
  Write-Host "do not rebase commits pushed to public repo!"
  Write-Host "git rebase master                       | take the changes committed on master and replay them over current branch"
  Write-Host "git merge --no-ff x                     | take the changes committed on x and merge them into current branch (with a merge commit)"
  Write-Host "Remember: " -NoNewLine
  Write-Host "http://nvie.com/posts/a-successful-git-branching-model/" -ForegroundColor magenta
  Write-Host "Delete-AllUntracked: git status --porcelain | where { `$_.StartsWith(`"??`") } | foreach-object { del `$_.replace(`"?? `", `"`") } | delete all untracked files"
  Write-Host "Unstage-AllDeleted: git status --porcelain | where { `$_.StartsWith(`" D`") } | foreach-object { git reset HEAD `$_.replace(" D ", `"`") } | unstage all deleted files"
  Write-Host "Get-PrettyLogForFile x"
  Write-Host "Get-SpecificBlame file hash startLine numberLines"
  Write-Host "Save-Work: git stash save -u"
  Write-Host "Get-Work: git stash apply"
  write-host "git grep name -- * :!node_modules     | search for 'name' recursively in all dirs excluding node modules"
}

