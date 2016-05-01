---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 4"
date: 2016-02-13 16:19
comments: true
categories: [ruby, gosu, jeu, 2d]
---

Dans cet article on va s'occuper de gérer les vies de notre joueur.
On va les afficher et les perdre.

{% img center /images/gosu5.png %}

<!-- more -->

La totalité des articles:

1. [Installation de Gosu, affichage d'images statiques](/blog/2016/02/10/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-1/)
2. [Déplacer le joueur et pluie de smileys](/blog/2016/02/11/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-2/)
3. [Beep, fonte et collecte des smileys](/blog/2016/02/12/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-3/)
4. On s'occupe des vies
5. [Musique et game over](/blog/2016/02/15/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-5/)
6. [Affichage selon un angle](/blog/2016/02/25/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-6/)
7. [Plusieurs musiques et reset de la partie](/blog/2016/05/01/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-7/)

## Sourire à l'envers : autre son et pas de points

Pour l'instant notre joueur collecte tout les smileys. Quel qu'ils soient.
Or, si les smiley oranges (sourire à l'endroit) doivent rapporter des points, les
smileys verts (sourire à l'envers) doivent eux faire perdre une vie à notre joueur.

On va commencer simplement par ne pas augmenter le score et jouer un son
différent quand le joueur entre en collision avec un smiley vert.
Dans la classe Player on charge le nouveau son (`life-lost.wav`) et on
modifie la méthode `collision` pour qu'elle réagisse au type du smiley:

```ruby
class Player

  def initialize
    # ...
    @sound_life_lost = Gosu::Sample.new("assets/sound/life-lost.wav")
  end

  def collect(items)
    items.reject! {|item| collide?(item) ? collision(item.type) : false }
  end

  def collision(type)
    case type
    when :smiley_up
      @score += 10
      @sound_collect.play(1.0)
    when :smiley_down
      @sound_life_lost.play(1.0)
    end

    true
  end

end
```

Il ne faut pas oublier d'ajouter une méthode `type` à la classe Smiley:

```ruby
class Smiley
  attr_reader :x, :y, :type

  def initialize(type)
    @type = type
    # ...
  end

end
```

Avouez que c'était simple…

## Afficher les vies

L'objectif de cet article est de gérer les vies du joueur. Pour cela,
commençons par lui en donner 3:

```ruby player.rb
class Player

  # ...

  attr_reader :score, :lives

  def initialize
    # ...
    @lives = 3
  end

end
```

Les vies seront affichées au niveau de l'UI, c'est donc dans la classe du même
nom que cela va se passer. Jusqu'ici l'UI n'affichait que le score, et c'était
ce score que recevait en paramètre la méthode `draw`. On va modifier cela pour
pouvoir afficher le score et les vies.

On charge une nouvelle image, `heart.gif`, qui va symboliser une vie.
Puis dans `draw_lives` on affiche autant de `heart.gif` qu'il y a de vies:

```ruby ui.rb
class UI
  ScoreX = 10
  ScoreY = 10
  ScoreColor = 0xff_ffff00

  LivesX = 10
  LivesXShift = 20
  LivesY = 30

  def initialize
    @font = Gosu::Font.new(20, name: "assets/fonts/VT323/VT323-Regular.ttf")
    @heart = Gosu::Image.new("assets/images/heart.gif")
  end

  def draw(player)
    draw_score(player.score)
    draw_lives(player.lives)
  end

  private

  def draw_score(score)
    @font.draw("Score: #{score}", ScoreX, ScoreY, ZOrder::UI, 1.0, 1.0,
               ScoreColor)
  end

  def draw_lives(number)
    number.times do |index|
      @heart.draw(LivesXShift * index + LivesX, LivesY, ZOrder::UI)
    end
  end
end
```

L'affichage des vies commence à la coordonnée x `LiveX` (soit 10), et se
poursuit en étant décalé à chaque fois de `LivesXShift` pixels vers la droite (soit 20).

Pour finir, il faut modifier l'appel à `UI#draw` depuis la classe `Window`:

```ruby window.rb
class Window < Gosu::Window
  def draw
    # ...
    @ui.draw(@player)
  end
end
```

## Perdre une vie

Maintenant qu'on peut comptabiliser et afficher les vies du joueur, on est
prêt à lui en faire perdre. Il n'y a qu'une seule ligne à ajouter:

```ruby
class Player
  def collision(type)
    case type
    when :smiley_up
      @score += 10
      @sound_collect.play(1.0)
    when :smiley_down
      @lives -= 1                # <----------------- Ici
      @sound_life_lost.play(1.0)
    end

    true
  end
end
```

Cette méthode `collision` est déjà trop longue à mon goût, mais je préfère
attendre qu'elle enfle encore avant d'y remédier. Je veux être certain que
même les plus débutant(e)s d'entre vous puissent voir cette méthode devenir
hors de contrôle avant de proposer une solution qui pourrait être vue comme
trop compliquée dans cette version.

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
    │   └── sound
    │       ├── collect.wav
    │       └── life-lost.wav
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── ui.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.4.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.4.0).

{% connexe %}
