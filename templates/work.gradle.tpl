def workRoot = new File(System.getProperty('user.home'), 'ghq/{{ op://dotfiles/work/git/domain }}').canonicalPath + File.separator

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
    if ((rootDir.canonicalPath + File.separator).startsWith(workRoot)) {
        workMaven(buildscript.repositories)
        workMaven(repositories)
    }
}
