---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 6"
date: 2016-02-25 11:37
comments: true
categories: [ruby, gosu, jeu, 2d]
---

Pour augmenter l'effet dramatique lorsque le joueur perd une vie, je voudrais
que celui-ci se mette à tourner sur lui-même. Pour ça, on affichera l'image du
joueur selon un certain angle, et cet angle sera mis à jour à chaque appel de
`update`. Voyons cela pas à pas.

{% img center /images/gosu7.png %}

<!-- more -->

La totalité des articles:

1. [Installation de Gosu, affichage d'images statiques](/blog/2016/02/10/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-1/)
2. [Déplacer le joueur et pluie de smileys](/blog/2016/02/11/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-2/)
3. [Beep, fonte et collecte des smileys](/blog/2016/02/12/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-3/)
4. [On s'occupe des vies](/blog/2016/02/13/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-4/)
5. [Musique et game over](/blog/2016/02/15/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-5/)
6. Affichage selon un angle
7. [Plusieurs musiques et reset de la partie](/blog/2016/05/01/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-7/)

## Affichage selon un angle

Il nous faut d'abord un angle:

```ruby player.rb
  def initialize
    # ...
    @angle = 0.0
  end
```

Ensuite nous ajoutons une méthode `update` à la classe Player. Quand le joueur
vient de perdre une vie, la seule chose à mettre à jour est l'angle. Dans les
autres cas, on fait la même mise à jour qu'avant:

```ruby player.rb
  def update(items)
    just_lost_a_life? ? update_angle : update_general(items)
  end
```

La mise à jour de l'angle d'affichage de l'image du joueur ne demande pas
d'explications:

```ruby player.rb
  def update_angle
    @angle += 10
  end
```

En ce qui concerne la mise à jour générale, j'ai effectué un petit refactoring
pour passer dans la classe Player du code venant de la classe Window, et qui
n'avait pas à s'y trouver. Au passage j'ai aussi créé le module `Button` qu'on
verra plus tard:

```ruby player.rb
  def update_general(items)
    go_left if Button.left?
    go_right if Button.right?
    move
    collect(items)
  end
```

On peut maintenant regarder l'affichage. Pour afficher une image selon un
certain angle, Gosu propose la méthode `draw_rot`. L'image sera orientée par
rapport à un point précis, ici je choisi le centre de l'image:

```ruby player.rb
  def draw
    if just_lost_a_life?
      @image.draw_rot(x_middle, y_middle, ZOrder::Player, @angle)
    else
      @image.draw(@x, Y, ZOrder::Player)
    end
  end

  alias_method :x_middle, :x_center_of_mass

  def y_middle
    Y + @image.height / 2
  end
```

Voici tout ce qui change dans la classe `Player` en un coup d'œil:

```ruby
class Player

  def initialize
    # ...
    @angle = 0.0
  end

  def update(items)
    just_lost_a_life? ? update_angle : update_general(items)
  end

  def draw
    if just_lost_a_life?
      @image.draw_rot(x_middle, y_middle, ZOrder::Player, @angle)
    else
      @image.draw(@x, Y, ZOrder::Player)
    end
  end

  alias_method :x_middle, :x_center_of_mass

  def y_middle
    Y + @image.height / 2
  end

  def update_angle
    @angle += 10
  end

  def update_general(items)
    go_left if Button.left?
    go_right if Button.right?
    move
    collect(items)
  end

end
```

Voici maintenant le contenu du module `Button`:

```ruby
module Button

  def self.left?
    Gosu::button_down?(Gosu::KbLeft)
  end

  def self.right?
    Gosu::button_down?(Gosu::KbRight)
  end

end
```

On peut légitimement se demander «Mais pourquoi ajouter un tel module ?».
Simplement parce que je préfère 100 fois lire ceci:

    do_this if Button.left?

… plutôt que cela:

    do_this if Gosu::button_down?(Gosu::KbLeft)

Voyons enfin ce qui change dans la classe Window.
J'ai déplacé la ligne `return if @player.just_lost_a_life?` de la méthode
`update` vers la méthode `update_items`. Ainsi la méthode `update_player` est
toujours appelée et peut changer l'angle d'affichage du joueur:

```ruby
class Window < Gosu::Window
  def update
    return if @game_over

    update_items
    update_player
  end

  def update_items
    return if @player.just_lost_a_life?
    # ...
  end

  def update_player
    @player.update(@items)
    @game_over = true if @player.lives <= 0
  end

end
```

Pour finir, voici le contenu du jeu pour l'instant:

    $ tree
    .
    ├── assets
    │   ├── fonts
    │   │   └── VT323
    │   │       ├── OFL.txt
    │   │       └── VT323-Regular.ttf
    │   ├── images
    │   │   ├── background.png
    │   │   ├── heart.gif
    │   │   ├── player.png
    │   │   ├── smiley-green.png
    │   │   └── smiley-yellow.png
    │   ├── songs
    │   │   └── Around the Bend.ogg
    │   └── sound
    │       ├── collect.wav
    │       └── life-lost.wav
    ├── button.rb
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── ui.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.6.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.6.0).

{% connexe %}
