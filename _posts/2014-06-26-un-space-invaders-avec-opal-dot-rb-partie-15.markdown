---
layout: post
title: "Un space invaders avec Opal.rb - partie 15"
date: 2014-06-26 21:09
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



Vous en avez peut-être marre de tapez `rake build` à chaque petite
modification de votre code ? Moi, oui. En utilisant Sprockets, on peut
rendre le build automatique. Cool.

<!-- more -->

La marche à suivre est décrite dans la [documentation d'Opal](http://opalrb.org/docs/using_sprockets/).
Basiquement, on ajoute un fichier `config.ru` à la racine:

{% highlight ruby %}
require 'bundler'
Bundler.require

run Opal::Server.new { |s|
  s.append_path 'app'
  s.main = 'application'
  s.index_path = 'index.html'
}
{% endhighlight %}

Et on change la localisation du script dans `index.html`:

{% highlight html %}
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
{% endhighlight %}

Après quoi on lance l'application rack:

    $ bundle exec rackup

Et votre appli est accessible à l'adresse `localhost:9292`.

Maintenant tout changement de code demande seulement un raffraichіssement
dans le navigateur.



À demain.


