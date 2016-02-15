---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 5"
date: 2016-02-15 09:12
comments: true
categories: [ruby, gosu, jeu, 2d]
---

Aujourd'hui on ajoute de la musique de fond, on s'intéresse à ce qui se passe
quand on perd une vie, et on écrit un beau «Game Over» quand on a perdu toutes
les vies.

{% img center /images/gosu6.png %}

<!-- more -->

La totalité des articles:

1. [Installation de Gosu, affichage d'images statiques](/blog/2016/02/10/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-1/)
2. [Déplacer le joueur et pluie de smileys](/blog/2016/02/11/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-2/)
3. [Beep, fonte et collecte des smileys](/blog/2016/02/12/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-3/)
4. [On s'occupe des vies](/blog/2016/02/13/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-4/)
5. Musique et game over

## De la musique

Ajouter une musique de fond est très simple avec Gosu. On crée la ressource
comme on a créé des sons ou des images. Ensuite on règle le volume entre
0 et 1. Et enfin on appuie sur `play`:

```ruby
class Window < Gosu::Window

  def initialize(width, height)
    # ...
    @song = Gosu::Song.new("assets/songs/Around the Bend.ogg")
    @song.volume = 0.25
    @song.play(true)
  end

end
```

Le paramètre `true` passé à la méthode `play` lui indique qu'on veut jouer la
musique en boucle.

> Un paramètre booléen est ce que j'appelle un «paramètre de contrôle»
> (Martin Fowler appelle ça un [Flag argument](http://martinfowler.com/bliki/FlagArgument.html).
> C'est un bon vieux code smell et je suis un peu déçu de trouver ça dans Gosu.
> Surtout qu'il est ici facile de s'en débarrasser en proposant deux méthodes sans paramètres,
> par exemple `play` et `loop`.

## Petite pause quand on perd une vie

Pour marquer le coup, je voudrais que le jeu *pause* pendant un certain temps
(ici une seconde et demi) quand le joueur perd une vie. Voici d'abord le code,
puis les explications:

```ruby
class Player

  # ...
  LifeLostPause = 1500

  def initialize
    # ...
    @lost_life_at = -20_000
  end

  def just_lost_a_life?
    Gosu::milliseconds - @lost_life_at < LifeLostPause
  end

  private

  def collision(type)
    case type
    when :smiley_up
      # ...
    when :smiley_down
      # ...
      @lost_life_at = Gosu::milliseconds
    end

    true
  end

end
```

Commençons par ce qui change dans `collision`. Lorsque le joueur entre en
collision avec un smiley à l'envers, j'enregistre l'instant de cette collision.
`Gosu::milliseconds` retourne le nombre de millisecondes écoulées depuis le
début du jeu.

Pour savoir si le joueur vient de perdre une vie, la méthode `just_lost_a_life?`
compare le temps présent (`Gosu::milliseconds`) avec l'instant où le joueur a
perdu une vie (`@lost_life_at`). Si la différence est de moins de 1500
millisecondes (une seconde et demi) `just_lost_a_life?` retournera `true`.

Lors de l'initialisation on trouve cette ligne:

    @lost_life_at = -20_000

… qui est nécessaire pour que `@lost_life_at` ne soit pas `nil` au début
du jeu, ce qui provoquerait une erreur dans `just_lost_a_life?`. Mais pourquoi
-20,000 ? Essayez de la définir à zéro pour voir… En fait -20,000 est une
valeur arbitraire, qui aurait aussi bien pu être -10,000 ou -9999, etc.
Une autre solution aurait été d'écrire `just_lost_a_life?` comme ceci:

```ruby
def just_lost_a_life?
  if @lost_life_at
    Gosu::milliseconds - @lost_life_at < LifeLostPause
  else
    false
  end
end
```

Mais j'aime moins cette solution, pour deux raisons, 1) c'est moins performant
puisqu'on a un test de plus à chaque update (ok c'est pas grand chose, mais ça
plus ça plus ça…, et là c'est très facilement évitable pour rien) et 2) je préfère que toutes les variables d'objets soient
définies dans le constructeur (peut-être un vieux reste de mon passé de
javaïste, ou un truc comme ça).

Quoiqu'il en soit, la ligne `@lost_life_at = -20_000` mérite un commentaire
expliquant la raison de cette valeur arbitraire. J'espère que ce sera
compréhensible:

```ruby
    # It's important to note that this value is necessary for the game
    # to avoid to freeze at startup.
    # −20_000 is an arbitrary value. One can use -9999 or -5000 instead.
    @lost_life_at = -20_000
```

Pour que tout ceci fonctionne, il suffit maintenant d'esquiver les updates au
bon moment:

```ruby
class Window < Gosu::Window

  def update
    return if @player.just_lost_a_life?

    update_items
    update_player
  end

end
```

## Game over quand 0 vies

Vous avez maintenant compris que j'avance par petites itération successives,
qui ne sont d'ailleurs pas toujours des fonctionnalités complètes.
Cette fois on va afficher «Game Over» et geler le jeu quand le joueur atteint
zéro vies:

```ruby
class Window < Gosu::Window

  def initialize(width, height)
    # ...
    @game_over = false
  end

  def update
    return if @player.just_lost_a_life?
    return if @game_over
    # ...
  end

  def draw
    # ...
    @ui.draw(game_state)
  end

  private

  # ...

  def update_player
    # ...
    @game_over = true if @player.lives <= 0
  end

  def game_state
    {
      score: @player.score,
      lives: @player.lives,
      game_over: @game_over,
    }
  end

end
```

Ce qui mérite des explications c'est ce nouveau `game_state`. Plutôt que
d'envoyer les informations à l'UI sous la forme `@ui.draw(@player, @game_over)`
je préfère envoyer un *état* du jeu. Tout d'abord je n'envoie que le nécessaire
et ensuite on a un seul paramètre et non pas une liste de paramètres condamnée
à enfler.

Reste à refléter ça dans la classe UI:

```ruby
class UI
  # ...

  def initialize
    # ...
    @big_font = Gosu::Font.new(80, name: "assets/fonts/VT323/VT323-Regular.ttf")
  end

  def draw(game)
    draw_score(game[:score])
    draw_lives(game[:lives])
    draw_game_over if game[:game_over]
  end

  private

  def draw_game_over
    @big_font.draw_rel("Game Over",
                       WindowWidth / 2, WindowHeight / 2,
                       ZOrder::UI,
                       0.5, 0.5)
  end

end
```

La nouveauté est la méthode `draw_rel`, qui va écrire son texte
*relativement* à lui-même. Oui je sais, ça sonne bizarre. Mais si vous
essayez les valeurs 0 et/ou 1 à la place de 0.5, vous devriez vite comprendre.
Là on va centrer le texte autour du milieu de l'écran, à la fois
horizontalement et verticalement.

> Le fait que `draw_rel` soit l'abréviation de `draw_relative` ne sautera pas
> forcement aux yeux de tout le monde. Alors pourquoi avoir utilisé une
> abréviation ?

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
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── ui.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.5.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.5.0).

{% connexe %}
