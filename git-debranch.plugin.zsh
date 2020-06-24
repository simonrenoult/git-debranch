function debranch {
    if [ -z "$1" ]; then
        echo "Error: a commit ref must be provided"
    else
        local current_branch=$(git rev-parse --abbrev-ref HEAD)
        local commit_to_extract="$1"
        local branch_to_create="debranch-${commit_to_extract}"

        echo "> Committing current changes in a temporary commit"
        git add --all
    	git commit --allow-empty --message="wip: undo me with 'git reset --soft HEAD~'"
        echo
        
        echo "> Moving to the new branch '${branch_to_create}'"
        git checkout -b $branch_to_create master
        echo
        
        echo "> Cherry-picking '${commit_to_extract}' on '${branch_to_create}'"
        git cherry-pick $commit_to_extract
        echo

        echo "> Moving back to '${current_branch}'"
        git checkout $current_branch
        echo

        echo "> Undoing the temporary commit on '${current_branch}'"
        git reset --soft HEAD~
        echo

        echo "> Branch '${branch_to_create}' has been created, it contains '${commit_to_extract}'"
        echo
    fi
}
compdef _git debranch=git-checkout

function debranch-and-push {
    local commit_to_extract="$1"
    local branch_to_create="debranch-${commit_to_extract}"
    
    debranch $commit_to_extract

    echo "> Pusing '${branch_to_create}' to origin"
    git push origin $branch_to_create
    echo
}
compdef _git debranch-and-push=git-checkout
