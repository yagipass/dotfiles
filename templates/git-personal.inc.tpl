[user]
	name = {{ op://dotfiles/personal/git/name }}
	email = {{ op://dotfiles/personal/git/email }}
	signingkey = key::{{ op://dotfiles/git-personal-signing-key/public key }}
[commit]
	gpgsign = true
[tag]
	gpgsign = true
