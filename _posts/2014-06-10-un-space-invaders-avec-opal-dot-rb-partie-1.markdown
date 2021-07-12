---
layout: post
title: "Un space invaders avec Opal.rb - partie 1"
date: 2014-06-10 21:25
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



Après une courte [introduction à Opal.rb](blog/2014/06/06/introduction-a-opal-dot-rb/),
on va essayer de faire un truc plus ambitieux avec Opal: un jeu du genre
Space Invaders.

<!-- more -->

Pour ce jeu, je vais utiliser jQuery pour manipuler le DOM, parce que c'est
plus simple ;) On va aussi utiliser une structure de dossier un peu plus
*pro* que dans l'introduction et un Gemfile que voici:

{% highlight ruby %}
source 'https://rubygems.org'

gem 'opal', '~>0.6'
gem 'opal-jquery'
{% endhighlight %}

Au fait, Opal.rb supporte Ruby à partir de la version 2.0.

Il nous faut à présent un fichier HTML:

{% highlight html %}
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
{% endhighlight %}

Vous remarquerez l'inclusion de jQuery, d'un canvas pour notre jeu et d'un
script `build.js` qui est notre objectif.

Maintenant, voici un Rakefile qui va justement construire ce fameux
`build.js`:

{% highlight ruby %}
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
{% endhighlight %}

Si vous vous posez des questions sur ce fichier, les réponses sont sur
la [documentation d'Opal](http://opalrb.org/docs/static_applications/).

On s'occupe maintenant de notre canvas avec une classe Ruby qui va afficher
un arrière-plan noir:

{% highlight ruby %}
require 'opal'
require 'opal-jquery'

class SpaceCanvas

  def initialize
    @canvas  = `document.getElementById('canvas')`
    @context = `#@canvas.getContext('2d')`
    @height  = `#@canvas.height`
    @width   = `#@canvas.width`
  end

  def clear_background
    `#@context.fillStyle = 'black'`
    `#@context.fillRect(0, 0, #{@width}, #{@height})`
  end
end

canvas = SpaceCanvas.new
canvas.clear_background
{% endhighlight %}

Les explications ligne par ligne de cette classe seront demain dans le prochain
car je suis préssé par le temps…

Pour construire le fichier `build.js`, on se sert de rake:

    rake build

Il suffit maintenant d'ouvrir le fichier HTML pour voir apparaitre un beau
rectangle tout noir ;)

Pour infos, voici la structure de notre jeu:

    ● tree
    .
    ├── app
    │   └── application.rb
    ├── build.js
    ├── Gemfile
    ├── Gemfile.lock
    ├── index.html
    └── Rakefile



À demain.


