# Nick Command Module

Set-Alias g git

function Create-Github {
    param (
        [string]$repoName
    )

    $headers = @{
       "Accept" = "application/vnd.github.v3+json";
       "Content-Type" = "application/json";
       "Authorization" = "token 38e271deab9cd4451c3ae26b9b97dd1133e9474b";
    }

    $json = "{`"name`":`"" + $repoName + "`"}"

    Invoke-WebRequest -Uri https://api.github.com/user/repos -Headers $headers -Method Post -Body $json

    git remote rm origin

    git remote add origin ("https://github.com/nickmeldrum/" + $repoName + ".git")

    git push -u origin master
}
