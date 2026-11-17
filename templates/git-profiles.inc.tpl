[includeIf "gitdir:~/ghq/{{ op://dotfiles/work/git/domain }}/"]
	path = ~/.config/git/work.inc
[includeIf "gitdir:~/ghq/{{ op://dotfiles/personal/git/domain }}/"]
	path = ~/.config/git/personal.inc
[includeIf "gitdir:~/ghq/{{ op://dotfiles/personal/git/domain }}/{{ op://dotfiles/work/github/name }}/"]
	path = ~/.config/git/work-github.inc
[includeIf "gitdir:~/ghq/{{ op://dotfiles/personal/git/domain }}/{{ op://dotfiles/work/github/org }}/"]
	path = ~/.config/git/work-github.inc
[credential "https://{{ op://dotfiles/work/git/domain }}"]
	helper =
	helper = !gh auth git-credential
	username = {{ op://dotfiles/work/git/name }}
[credential "https://{{ op://dotfiles/personal/git/domain }}"]
	helper =
	helper = !gh auth git-credential
	username = {{ op://dotfiles/personal/git/name }}
[credential "https://{{ op://dotfiles/personal/git/domain }}/{{ op://dotfiles/work/github/name }}"]
	username = {{ op://dotfiles/work/github/name }}
[credential "https://{{ op://dotfiles/personal/git/domain }}/{{ op://dotfiles/work/github/org }}"]
	username = {{ op://dotfiles/work/github/name }}
