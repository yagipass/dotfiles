<settings xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <servers>
    <server>
      <id>{{ op://dotfiles/work/maven/id }}</id>
      <username>{{ op://dotfiles/work/maven/username }}</username>
      <password>{{ op://dotfiles/work/maven/password }}</password>
    </server>
  </servers>
  <mirrors>
    <mirror>
      <id>{{ op://dotfiles/work/maven/id }}</id>
      <name>Work Maven Repository</name>
      <url>{{ op://dotfiles/work/maven/url }}</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
