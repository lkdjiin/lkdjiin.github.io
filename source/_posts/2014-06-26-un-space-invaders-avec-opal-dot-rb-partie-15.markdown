---
layout: post
title: "Un space invaders avec Opal.rb - partie 15"
date: 2014-06-26 21:09
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Vous en avez peut-être marre de tapez `rake build` à chaque petite
modification de votre code ? Moi, oui. En utilisant Sprockets, on peut
rendre le build automatique. Cool.

<!-- more -->

La marche à suivre est décrite dans la [documentation d'Opal](http://opalrb.org/docs/using_sprockets/).
Basiquement, on ajoute un fichier `config.ru` à la racine:

``` ruby config.ru
require 'bundler'
Bundler.require

run Opal::Server.new { |s|
  s.append_path 'app'
  s.main = 'application'
  s.index_path = 'index.html'
}
```

Et on change la localisation du script dans `index.html`:

``` html index.html
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

Après quoi on lance l'application rack:

    $ bundle exec rackup

Et votre appli est accessible à l'adresse `localhost:9292`.

Maintenant tout changement de code demande seulement un raffraichіssement
dans le navigateur.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
