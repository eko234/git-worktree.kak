# git-worktree.kak

easy navigation on git work trees, this plugin provides some hooks to handle its
state, and (for now) two commands `worktree-add-branch`, that will allow you to
add a branch to your worktree, it will show you candidates matching remote
available branches and `worktree-goto-branch` that will cd you to one of
your local branches, once in a branch you can jump between branches with this
same command, NOTE that this plugin assumes that once it finds a tree it will
stick to it as THE tree, you can navigate other locations and git-worktree.kak
will not interfere with any of your afairs, but it will stick to the first base
worktree it finds to provide the plugin functionalities, this coudl change in
the future, but for now its good enough.

# TODO:

provide an option to magically match files between branches


## suggested config

``` kak
plug "eko234/git-worktree.kak" config %{
  alias global wg worktree-goto-branch
  alias global wa worktree-add-branch
}
```
