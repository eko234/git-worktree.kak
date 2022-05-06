declare-option str worktree_directory
declare-option str worktree_current_branch
declare-option bool worktree_magic_match

# here comes the tricky part, as one may want to keep the buffer list when going
# to another, we should suppose there is no plugin to handle buffers and regs as I currently
# do, also the local kakrc, if user uses one, should be in the worktree dir to be caught, we should
# provide a hook to execute commands when picking a branch in a worktree, there is no way
# to know what a user might want to happen when doing so, for example, I would want to
# rematch my recent buffers

define-command update-worktree-directory -override %{
  evaluate-commands %sh{
    if [ -z $kak_opt_worktree_directory ]; then
      while [ "$PWD" != "/" ]; do
        if [ -d worktrees ]; then
          printf %s\\n "set-option global worktree_directory '$PWD'"
          break
        fi
        cd ..
      done
    fi
  }
}

define-command update-worktree-current-branch %{
  evaluate-commands %sh{
    branch=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
    if [ -n "${branch}" ]; then
      printf 'set-option global worktree_current_branch %%{%s}' "${branch}"
    fi
  }
}

hook global KakBegin .* %{
  update-worktree-directory
  update-worktree-current-branch
}

define-command worktree-add-branch -override -params 1 -shell-script-candidates %{
  cd "$kak_opt_worktree_directory"
  git branch -r | cut -d' ' -f2
} %{
  evaluate-commands %sh{
    cd "$kak_opt_worktree_directory"
    git worktree add $1 > /dev/null  && echo "echo branch $1 added" || echo "echo error adding branch $1"
  }
}

define-command worktree-goto-local-branch -override -params 1 -shell-script-candidates %{
  cd "$kak_opt_worktree_directory"
  git branch | cut -d' ' -f2 | grep -v "'$kak_opt_worktree_current_branch\|^$'"
} %{
  evaluate-commands %{
    cd "%opt{worktree_directory}/%arg{1}"
    update-worktree-directory
    update-worktree-current-branch
  }
}
