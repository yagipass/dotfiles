def workMaven = { repos ->
    repos.maven {
        url '{{ op://dotfiles/work/maven/url }}'
        credentials {
            username '{{ op://dotfiles/work/maven/username }}'
            password '{{ op://dotfiles/work/maven/password }}'
        }
    }
}

allprojects {
    workMaven(buildscript.repositories)
    workMaven(repositories)
}
