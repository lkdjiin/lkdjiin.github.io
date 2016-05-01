---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 2"
date: 2016-02-11 09:40
comments: true
categories: [ruby, gosu, jeu, 2d]
---

Aujourd'hui on voit comment déplacer et contrôler le joueur, ainsi que
comment faire tomber une pluie de smileys.

{% img center /images/gosu3.png %}

<!-- more -->

La totalité des articles:

1. [Installation de Gosu, affichage d'images statiques](/blog/2016/02/10/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-1/)
2. Déplacer le joueur et pluie de smileys
3. [Beep, fonte et collecte des smileys](/blog/2016/02/12/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-3/)
4. [On s'occupe des vies](/blog/2016/02/13/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-4/)
5. [Musique et game over](/blog/2016/02/15/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-5/)
6. [Affichage selon un angle](/blog/2016/02/25/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-6/)
7. [Plusieurs musiques et reset de la partie](/blog/2016/05/01/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-7/)

## Déplacer le joueur

On ajoute la méthode `update` à la classe `Window`. À l'instar de `draw`
cette méthode vient aussi de `Gosu::Window` et est appelée régulièrement.
Dans `draw` on dessine, on affiche. Dans `update` on calcule, on met à jour
les éléments du jeu.

> `update` sera appelée 60 fois par seconde quoiqu'il arrive, par contre
> `draw` pourra être appelée plus ou moins souvent suivant les besoins de
> l'OS. C'est pour cela qu'il est important de séparer le calcul de l'affichage.
> Cette division entre calcul et affichage est d'ailleurs typique d'un framework de jeu,
> ou même GUI, quelque soit le langage utilisé.

Le nouveau code de `Window` est le suivant:

```ruby window.rb
class Window < Gosu::Window

  def initialize(width, height)
    super
    self.caption = "Collect The Smile!"

    @background_image = Gosu::Image.new("assets/images/background.png")

    @player = Player.new
  end

  def update
    @player.go_left if Gosu::button_down?(Gosu::KbLeft)
    @player.go_right if Gosu::button_down?(Gosu::KbRight)

    @player.move
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
  end

end
```

Dans `update` on utilise la méthode `button_down?` de Gosu pour tester si le
joueur appuit sur la touche gauche et/ou la touche droite. L'appui simultané sur
les deux touches *annulera* en quelque sorte le déplacement. Et dans tout les cas
on déplace le joueur avec `@player.move`.

Voyons maintenant la classe `Player`, qui a gagné plusieurs nouvelles méthodes
par rapport au dernier article:

```ruby player.rb
class Player

  Y = 390

  def initialize
    @x = WindowHeight / 2
    @velocity = 0.0
    @image = Gosu::Image.new("assets/images/player.png")
  end

  def draw
    @image.draw(@x, Y, ZOrder::Player)
  end

  def go_left
    @velocity -= 0.5
  end

  def go_right
    @velocity += 0.5
  end

  def move
    @x += @velocity
    @x %= WindowWidth
    @velocity *= 0.96
  end

end
```

Le joueur se déplaçant toujours sur la même ligne, sa coordonnée y ne change
pas, j'en ai donc fait une constante.

L'idée générale pour le déplacement, c'est qu'il soit *smooth*, avec une
accélération progressive et une glisse finale. On a donc un facteur
d'accélération de 0.5 et un facteur de glisse de 0.96. Prenez le temps de jouer
avec ces valeurs pour les comprendre, et peut-être pour en trouver d'autres qui vous
conviennent mieux.

Comme toujours, nous convertirons ces nombres magiques en constantes:

```ruby player.rb
class Player

  Y = 390
  AccelerationFactor = 0.5
  SkidingFactor = 0.96

  # ...

  def go_left
    @velocity -= AccelerationFactor
  end

  def go_right
    @velocity += AccelerationFactor
  end

  def move
    @x += @velocity
    @x %= WindowWidth
    @velocity *= SkidingFactor
  end

end
```

## Une pluie de smileys

Il est temps de faire pleuvoir des smileys !

Ajoutez un fichier `smiley.rb`:

```ruby main.rb
require 'gosu'

require_relative 'z_order'
require_relative 'player'
require_relative 'smiley'
require_relative 'window'

# ...
```

Et remplissez le avec le code suivant:

```ruby smiley.rb
class Smiley
  attr_reader :y

  def initialize(type)
    @image = if type == :smiley_up
               Gosu::Image.new("assets/images/smiley-yellow.png")
             elsif type == :smiley_down
               Gosu::Image.new("assets/images/smiley-green.png")
             end

    @velocity = Gosu::random(0.8, 3.3)

    @x = rand * (WindowWidth - @image.width)
    @y = 0
  end

  def update
    @y += @velocity
  end

  def draw
    @image.draw(@x, @y, ZOrder::Items)
  end

end
```

Il n'y a rien de vraiment nouveau par rapport à ce qu'on a vu jusqu'ici.
Je peux toutefois signaler la méthode `Gosu::random(0.8, 3.3)`, qui retourne
un Float entre 0.8 inclus et 3.3 exclus. Et aussi le calcul de `@x`:

    @x = rand * (WindowWidth - @image.width)

qui soustrait la largeur du smiley de la largeur de la fenêtre pour s'assurer
qu'un smiley sera toujours dans les limites de la fenêtre (visible, donc).

Pour intégrer les smileys au jeu, vous devez modifier les méthodes
`initialize`, `update` et `draw` de la classe Window:

```ruby window.rb
class Window < Gosu::Window

  def initialize(width, height)

    # ...

    @items = []
  end

  def update
    unless @items.size >= 15
      r = rand
      if r < 0.035
        @items.push(Smiley.new(:smiley_up))
      elsif r < 0.040
        @items.push(Smiley.new(:smiley_down))
      end
    end
    @items.each(&:update)
    @items.reject! {|item| item.y > WindowHeight }

    # Les 3 lignes suivantes sont décrites dans l'article précédent.
    @player.go_left if Gosu::button_down?(Gosu::KbLeft)
    @player.go_right if Gosu::button_down?(Gosu::KbRight)
    @player.move
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)

    # Ça c'est la nouvelle ligne:
    @items.each(&:draw)

    @player.draw
  end

end
```

La nouvelle méthode `update` mérite bien quelques explications !
Tout d'abord je veux afficher un maximum de 15 smileys à l'écran:

```ruby
  def update
    if @items.size < 15
```

S'il y en a moins de 15, il y a *à chaque update* 3.5% de chances (0.035)
de créer un sourire à l'endroit, et 0.5% de chances (0.04 - 0.035) de créer un
sourire à l'envers:

```ruby
      r = rand
      if r < 0.035
        @items.push(Smiley.new(:smiley_up))
      elsif r < 0.040
        @items.push(Smiley.new(:smiley_down))
      end
    end
```

Dans tous les cas on met à jour les smileys existants (c'est à dire qu'on change leur
coordonnée y):

```ruby
    @items.each(&:update)
```

Et on supprime les smileys qui sont sortit de la fenêtre de jeu (par le bas):

```ruby
    @items.reject! {|item| item.y > WindowHeight }
```

Ce code est hideux et il faut faire quelque chose pour lui ;)
On commence le refactoring de la classe Window en extrayant les deux méthodes
`update_items` et `update_player`:

```ruby window.rb
class Window
  # ...

  def update
    update_items
    update_player
  end

  private

  def update_items
    unless @items.size >= 15
      r = rand
      if r < 0.035
        @items.push(Smiley.new(:smiley_up))
      elsif r < 0.040
        @items.push(Smiley.new(:smiley_down))
      end
    end
    @items.each(&:update)
    @items.reject! {|item| item.y > WindowHeight }
  end

  def update_player
    @player.go_left if Gosu::button_down?(Gosu::KbLeft)
    @player.go_right if Gosu::button_down?(Gosu::KbRight)
    @player.move
  end

end
```

La nouvelle méthode `update_items` mérite aussi sa petite extraction:

```ruby window.rb
  def update_items
    populate_items
    @items.each(&:update)
    @items.reject! {|item| item.y > WindowHeight }
  end

  def populate_items
    return if @items.size >= 15

    type = rand
    if type < 0.035
      @items.push(Smiley.new(:smiley_up))
    elsif type < 0.040
      @items.push(Smiley.new(:smiley_down))
    end
  end
```

Maintenant `populate_items` est toujours moche, et on sent que cette méthode
risque d'enfler dans l'avenir. Mais je pense que c'est le moment d'arrêter le refactoring
pour éviter de tomber dans l'[overengineering](https://en.wikipedia.org/wiki/Overengineering)
et aussi parce que
[YAGNI](http://martinfowler.com/bliki/Yagni.html) !.

Pour finir, voici le contenu du jeu pour l'instant:

    $ tree
    .
    ├── assets
    │   └── images
    │       ├── background.png
    │       ├── player.png
    │       ├── smiley-green.png
    │       └── smiley-yellow.png
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.2.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.2.0).

{% connexe %}
