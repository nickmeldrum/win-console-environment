# Place the lines:
#     $githubUsername= "addusernamehere" and
#     $githubToken = "addtokenhere"
# in your Profile before running this script

# Run the Create-Github function on an already created local git repo to create a remote
# repo on github and push to it. (local repo must have at least 1 commit)

function Create-Github {
    param (
        [string]$repoName
    )

    $headers = @{
       "Accept" = "application/vnd.github.v3+json";
       "Content-Type" = "application/json";
       "Authorization" = ("token " + $githubToken);
    }

    $json = "{`"name`":`"" + $repoName + "`"}"

    Invoke-WebRequest -Uri https://api.github.com/user/repos -Headers $headers -Method Post -Body $json
    git remote rm origin
    git remote add origin ("https://github.com/" + $githubUsername + "/" + $repoName + ".git")
    git push -u origin master
}

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

Set-Alias g git
Set-Alias acg AddAndCommit-Git
Set-Alias log Get-PrettyLog

function Echo-GitCommands {
  Write-Title "Git commands:"

  Write-Host "g st, g ad, g cm `"msg`"                  | git status, stage everything, commit with msg"
  Write-Host "acg `"msg`"                               | add and commit with msg"
  Write-Host "Create-Github x                         | create a repo on github called x, make it the remote origin and push to it"
  Write-Host "git pull --rebase origin master         | pull master and rebase my changes on top of them"
  Write-Host "git push -u origin master               | push master branch up to github"
  Write-Host "git checkout -b x                       | create a new branch x and move to it"
  Write-Host "git checkout --track origin/x           | create a local branch tracking a remote branch x"
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
}