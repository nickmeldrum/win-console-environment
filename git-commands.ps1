# Place the lines:
#     $githubUsername= "addusernamehere" and
#     $githubToken = "addtokenhere"
# in your Profile before running this script

Set-Alias g git

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
