# Place the lines:
#     $githubUsername= "addusernamehere" and
#     $githubToken = "addtokenhere"
# in your Profile before running this script

Set-Alias g git
Set-Alias acg AddAndCommit-Git

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
  git st
  git cm $commitMessage
  git st
  git log -1
}

function Echo-GitCommands {
  Write-Title "Git commands:"

  write-host "g st, g ad, g cm `"msg`"        | git status, stage everything, commit with msg"
  write-host "acg `"msg`"                     | add and commit with msg"
  write-host "Create-Github x               | create a repo on github called x, make it the remote origin and push to it"
  write-host "git push -u origin master     | push master branch up to github"
  write-host "git checkout -b x             | create a new branch x and move to it"
  write-host "rebase workflow: ends up with clean linear history even when events happened in parallel"
  write-host "do not rebase commits pushed to public repo!"
  write-host "git rebase master             | take the changes committed on master and replay them over current branch"
  write-host "git merge --no-ff x           | take the changes committed on x and merge them into current branch (with a merge commit)"
  write-host "Remember: " -NoNewLine
  write-host "http://nvie.com/posts/a-successful-git-branching-model/" -ForegroundColor magenta
}