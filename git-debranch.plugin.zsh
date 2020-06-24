function debranch {
    if [ -z "$1" ]; then
        echo "Error: a commit ref must be provided"
    else
        local current_branch=$(git rev-parse --abbrev-ref HEAD)
        local commit_to_extract="$1"
        local branch_to_create="debranch-${commit_to_extract}"

        git add --all
    	git commit --message="wip: undo me with 'git reset --soft HEAD~'"
        git checkout -b $branch_to_create origin/master
        git cherry-pick $commit_to_extract
        git checkout $current_branch
        git reset --soft HEAD~
    fi
}
compdef _git debranch=git-checkout

function debranch-and-push {
    if [ -z "$1" ]; then
        echo "Error: a commit ref must be provided"
    else
        local current_branch=$(git rev-parse --abbrev-ref HEAD)
        local commit_to_extract="$1"
        local branch_to_create="debranch-${commit_to_extract}"

        git add --all
        git commit --message="wip: undo me with 'git reset --soft HEAD~'"
        git checkout -b $branch_to_create origin/master
        git cherry-pick $commit_to_extract
        git push origin $branch_to_create
        git checkout $current_branch
        git reset --soft HEAD~
    fi
}
compdef _git debranch-and-push=git-checkout
