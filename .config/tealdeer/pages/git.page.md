# Git

- Create empty branch

  `git switch --orphan emptyBranch`
  `git commit --allow-empty -m 'new empty branch'`
  `git push -u origin emptyBranch`

- Rename a branch

  `git branch -m <old_branch_name> <new_branch_name>`
  `git push -u origin <new_branch_name>`
  `git push origin --delete <old_branch_name>`
