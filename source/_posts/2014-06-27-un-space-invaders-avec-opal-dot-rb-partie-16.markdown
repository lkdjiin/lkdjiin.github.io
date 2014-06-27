---
layout: post
title: "Un space invaders avec Opal.rb - partie 16"
date: 2014-06-27 21:23
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Hier on a vu comment lancer une appli rack pour le développement. Seulement
je n'ai pas envie de choisir entre les deux méthodes. Je veux les deux !
Le serveur rack pour le développement, et le build classique du fichier
javascript pour la mise en production.

On va se bricoler deux tâches `rake` en quelques minutes pour obtenir ça.

<!-- more -->

Alors j'avertis tout de suite : le script n'est pas parfait. C'est malgré une
bonne base pour commencer.

Voici le nouveau `Rakefile`, dans lequel j'ai ajouté une tâche `development`
et une tâche `production`:

``` ruby Rakefile
require 'opal'
require 'opal-jquery'

desc "Build our app to build.js"
task :build do
  env = Opal::Environment.new
  env.append_path "app"

  File.open("build.js", "w+") do |out|
    out << env["application"].to_s
  end
end

desc 'Build app for production'
task :production => :build do
  cp 'app/templates/index_production.html', 'index.html'
end

desc 'Run development server'
task :development do
  cp 'app/templates/index_development.html', 'index.html'
  `bundle exec rackup`
end
```

Pour que le fichier `index.html` reflète le bon environnement, j'ai
ajouté un dossier `templates`, avec une version de chaque:

    $ tree app
    app
    ├── application.rb
    ├── enemies.rb
    ├── enemy.rb
    ├── fire.rb
    ├── game.rb
    ├── player.rb
    ├── space_canvas.rb
    └── templates
        ├── index_development.html
        └── index_production.html

Pour info, voici le contenu des templates:

``` html app/templates/index_development.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
  </head>
  <body>
    <canvas width="700" height="600" id="canvas"></canvas>
    <script src="assets/application.js"></script>
  </body>
</html>
```

``` html app/templates/index_production.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
  </head>
  <body>
    <canvas width="700" height="600" id="canvas"></canvas>
    <script src="build.js"></script>
  </body>
</html>
```

Alors oui, les templates sont redondants. Et si on doit modifier le contenu
de `index.html`, il faudra faire la modification sur les deux templates.
J'avais prévenu que ça n'était pas parfait ;) Par contre, pour cette appli
c'est bien suffisant.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
