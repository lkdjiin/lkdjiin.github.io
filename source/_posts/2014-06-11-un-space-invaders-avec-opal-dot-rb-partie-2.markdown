---
layout: post
title: "Un space invaders avec Opal.rb - partie 2"
date: 2014-06-11 12:19
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Hier j'ai commencé l'écriture d'un Space Invaders avec Opal.rb, et on a pu
afficher un beau canvas tout noir ;) Il manquait l'explication de la classe
`SpaceCanvas`, la voici.

<!-- more -->

``` ruby
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
```

Toute cette classe utilise un *truc* de Opal : ce qui se trouve entre
*backticks* est du javascript et on a accès à l'interpolation Ruby des
chaînes de caractères. En Ruby, les backticks permettent d'appeller une
commande externe, avec Opal c'est pareil, sauf que l'extérieur c'est
javascript.

Tout d'abord dans la méthode `initialize`, la première ligne:
 
``` ruby
    @canvas  = `document.getElementById('canvas')`
```

C'est du javascript pur et dur ;) On récupère un référence au canvas par
son ID et on stocke cette référence dans `@canvas`.

Les trois lignes suivantes utilisent le même truc avec en plus de l'interpolation:

``` ruby
    @context = `#@canvas.getContext('2d')`
    @height  = `#@canvas.height`
    @width   = `#@canvas.width`
```

On obtient une référence au *contexte* du canvas, ce qui sera utile pour
dessiner dedans et on récupère sa hauteur et sa largeur.

La méthode `clear_background` maintenant:

``` ruby
  def clear_background
    `#@context.fillStyle = 'black'`
    `#@context.fillRect(0, 0, #{@width}, #{@height})`
  end
```

On selectionne d'abord une couleur de remplissage avec:

    `#@context.fillStyle = 'black'`

Puis on remplit le canvas avec cette couleur:

    `#@context.fillRect(0, 0, #{@width}, #{@height})`

Notez que j'ai utilisé ici une autre écriture pour l'interpolation. La ligne
précédente est equivalente à:

    `#@context.fillRect(0, 0, #@width, #@height)`

J'aurais d'ailleurs du écrire comme ça pour être homogène ;)

La prochaine on affiche un joueur ?

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
