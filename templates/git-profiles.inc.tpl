[includeIf "gitdir:~/ghq/{{ op://dotfiles/work/git/domain }}/"]
	path = ~/.config/git/work.inc
[includeIf "gitdir:~/ghq/{{ op://dotfiles/personal/git/domain }}/"]
	path = ~/.config/git/personal.inc
[credential "https://{{ op://dotfiles/work/git/domain }}"]
	helper =
	helper = !gh auth git-credential
	username = {{ op://dotfiles/work/git/name }}
[credential "https://{{ op://dotfiles/personal/git/domain }}"]
	helper =
	helper = !gh auth git-credential
	username = {{ op://dotfiles/personal/git/name }}
