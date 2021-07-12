---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 7"
date: 2016-05-01 09:29
legacy: true
tags: [ruby, gosu, jeu, 2d]
---

Ça fait plus de 2 mois que je dois terminer ce jeu et cette série d'article, alors au boulot !

Pour cette nouvelle version je voudrais ajouter une musique différente pour le
game over.  Et aussi pouvoir enfin recommencer une nouvelle partie après
un *game over*.

{% img center /images/gosu8.png %}

<!-- more -->

La totalité des articles:

1. [Installation de Gosu, affichage d'images statiques](/blog/2016/02/10/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-1/)
2. [Déplacer le joueur et pluie de smileys](/blog/2016/02/11/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-2/)
3. [Beep, fonte et collecte des smileys](/blog/2016/02/12/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-3/)
4. [On s'occupe des vies](/blog/2016/02/13/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-4/)
5. [Musique et game over](/blog/2016/02/15/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-5/)
6. [Affichage selon un angle](/blog/2016/02/25/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-6/)
7. Plusieurs musiques et reset de la partie

## Plusieurs musiques

Nous allons devoir gérer plusieurs musiques. Donnons leur des noms plus simple
à manipuler que leurs *paths* :

{% highlight ruby %}
module Song
  GameOver = "assets/songs/In early time.ogg"
  Level1   = "assets/songs/Around the Bend.ogg"
end
{% endhighlight %}

Et avec quoi écoute-t-on de la musique ? Avec un *song player* :

{% highlight ruby %}
class SongPlayer
  def play(file)
    @song.stop if @song
    @song = Gosu::Song.new(file)
    @song.volume = 0.25
    @song.play(true)
  end
end
{% endhighlight %}

Dans la classe `Window` on remplace l'ancienne manière de jouer une musique :

{% highlight ruby %}
@song = Gosu::Song.new("assets/songs/Around the Bend.ogg")
@song.volume = 0.25
@song.play(true)
{% endhighlight %}

par notre nouvelle abstraction :

{% highlight ruby %}
@song_player = SongPlayer.new
@song_player.play(Song::Level1)
{% endhighlight %}

N'oubliez pas d'ajouter les require qui vont bien dans le fichier `main.rb` :

{% highlight ruby %}
require_relative 'song'
require_relative 'song_player'
{% endhighlight %}

Trouver un bon endroit où mettre le code pour changer la musique après un
*game over* n'est pas si 
évident que ça. Le moment où l'on capte que le jeu est dans l'état game over est
la méthode `update_player` :

{% highlight ruby %}
def update_player
  @player.update(@items)
  @game_over = true if @player.lives <= 0
end
{% endhighlight %}

Et il semblerait vraiment bizarre de modifier la musique alors qu'on est
sensé mettre à jour le joueur. Autrement dit, le code suivant ne me plait pas :

{% highlight ruby %}
def update_player
  @player.update(@items)
  if @player.lives <= 0
    @game_over = true
    @song_player.play(Song::GameOver)
  end
end
{% endhighlight %}

À bien y réfléchir, le problème vient d'avant. On ne devrait pas changer l'état
de `@game_over` ici, mais plutôt dans la méthode `update` :

{% highlight ruby %}
class Window < Gosu::Window
  def update
    return if @game_over

    @game_over = true if @player.lives <= 0
    update_items
    update_player
  end

  def update_player
    @player.update(@items)
  end
end
{% endhighlight %}

Changer la musique se fera donc de cette manière :

{% highlight ruby %}
def update
  return if @game_over

  if @player.lives <= 0
    @game_over = true
    @song_player.play(Song::GameOver)
  end

  update_items
  update_player
end
{% endhighlight %}

Après extraction d'une nouvelle méthode, nous obtenons un code plus clair :

{% highlight ruby %}
def update
  return if @game_over

  update_game_over
  update_items
  update_player
end

def update_game_over
  return unless @player.lives <= 0

  @game_over = true
  @song_player.play(Song::GameOver)
end
{% endhighlight %}

## Nouvelle partie

Ok, il est temps maintenant de pouvoir jouer une nouvelle partie après un
game over. Pour cela, il faut regarder si le joueur appuie sur la touche
espace pendant l'état game over, et dans ce cas faire un reset :

{% highlight ruby %}
def update
  reset if @game_over && Button.space?

  return if @game_over

  update_game_over
  update_items
  update_player
end
{% endhighlight %}

On peut tout de suite extraire une méthode `new_game?` :

{% highlight ruby %}
def update
  reset if new_game?
  # [...]
end

def new_game?
  @game_over && Button.space?
end
{% endhighlight %}

On peut maintenant réfléchir à la méthode `reset`, qui a son tour appellera
la méthode `reset` du joueur. Ces deux méthodes sont évidentes :

{% highlight ruby %}
class Window < Gosu::Window
  def reset
    @items = []
    @player.reset
    @song_player.play(Song::Level1)
    @game_over = false
  end
end
{% endhighlight %}

{% highlight ruby %}
class Player
  def reset
    @score = 0
    @lives = 3
    @angle = 0.0
    @velocity = 0.0
  end
end
{% endhighlight %}

Pour terminer cette version, on va ajouter un message «press space to start»
qui bouge pour attirer l'attention. Pour ça, on varie régulièrement d'une
petite quantité la coordonnée **y** du message.


{% highlight ruby %}
class UI
  # ...
  PressSpaceLow = 210
  PressSpaceHigh = 270

  def initialize
    # ...
    @y = 240
    @y_velocity = -0.3
  end

  private

  def draw_game_over
    @big_font.draw_rel("Game Over", WindowWidth / 2, WindowHeight / 3,
                       ZOrder::UI, 0.5, 0.5)
    @big_font.draw_rel("Press Space To Start", WindowWidth / 2, y,
                       ZOrder::UI, 0.5, 0.5)
  end

  def y
    @y += y_velocity
  end

  def y_velocity
    if @y < PressSpaceLow || @y > PressSpaceHigh
      @y_velocity = -@y_velocity
    end
    @y_velocity
  end
end
{% endhighlight %}

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
    │   │   ├── Around the Bend.ogg
    │   │   └── In early time.ogg
    │   └── sound
    │       ├── collect.wav
    │       └── life-lost.wav
    ├── button.rb
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── song_player.rb
    ├── song.rb
    ├── ui.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.7.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.7.0).


