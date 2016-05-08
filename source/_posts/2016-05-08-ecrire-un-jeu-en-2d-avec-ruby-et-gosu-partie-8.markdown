---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 8"
date: 2016-05-08 19:54
comments: true
categories: 
---
Dans ce 8ème article de la série consacrée à la création d'un jeu en 2d avec
Ruby et Gosu, nous allons mettre en place les niveaux.

{% img center /images/gosu9.png %}

<!-- more -->

## Juste la mécanique

Dans un premier temps, nous allons mettre en place un mécanisme qui permettra
d'avoir facilement des niveaux, mais nous garderons le jeu tel qu'il est
actuellement. J'ai décidé que les niveaux du jeu seraient configurés dans un
fichier YAML.  Voici donc un fichier de niveaux minimum :

```yaml levels.yaml
-
  song: "assets/songs/Around the Bend.ogg"
  goal: 15

-
  song: "assets/songs/Catch The Mystery.ogg"
  goal: 25
```

Chaque entrée dans le fichier YAML (donc chaque niveau dans le jeu) comporte
une musique et un objectif (*goal*).  Cet objectif est le nombre de sourires à
collecter pour terminer le niveau. On ajoutera bien sûr un tas d'autres choses
plus tard, mais c'est tout à fait suffisant pour la mise en place des niveaux
dans notre jeu.

Le chargement de ces niveaux peut se faire dans une classe `Level` :

```ruby level.rb
class Level

  def initialize
    @levels = YAML.load_file('levels.yaml')
  end

end
```

Le fichier de niveaux `levels.yaml` rend inutile le module `Song` développé
dans le dernier article. On peut donc le supprimer :

    rm song.rb

> On voit ici que le développement d'un jeu, comme toute application, n'est pas
> une simple ligne droite. 
> On ne se contente pas d'ajouter du code, on en supprime aussi.
> Une structure (ici notre module Song) peut être rendue obsolète après
> l'introduction d'une nouvelle structure, d'un nouveau design ou d'une
> nouvelle fonctionnalité. Il ne faut pas hésiter à se débarrasser d'un code qui
> n'est plus utile.

La musique pour l'état *game over* ne s'insère pas dans le schéma du fichier de
niveau. Nous pouvons créer une nouvelle méthode dans la classe SongPlayer et
l'utiliser là où il faut dans la classe Window :

```ruby song_player.rb
class SongPlayer
  def play_game_over
    play("assets/songs/In early time.ogg")
  end
end
```

```ruby
class Window < Gosu::Window
  def update_game_over
    # ...
    @song_player.play_game_over
  end
end
```

Pour que cela fonctionne, il faut mettre en place notre `Level` :

```ruby
class Window < Gosu::Window
  def initialize(width, height)
    # ...
    @level = Level.new
    @song_player = SongPlayer.new
    @song_player.play(@level.song) # <---- Cette méthode n'existe pas encore !
    #...
  end

  def reset
    # ...
    @song_player.play(@level.song) # <----- Idem !
    # ...
  end
end
```

Vous notez que j'utilise une méthode `Level#song` qui n'est pas encore codée.
Cette méthode devra retourner le nom de la musique du niveau actuel. Comme nous
n'avons pas encore cette notion de niveau actuel, trichons provisoirement et
retournons invariablement la musique du premier niveau :

```ruby
class Level
  def song
    @levels.first['song']
  end
end
```

Voilà, le jeu tourne exactement comme dans la version précédente, pourtant la
mécanique des niveaux est en place.

## Affichage des sourires collectés

Un bon premier pas serait de savoir où on en est dans la réalisation de
l'objectif du niveau. Autrement dit, on veut savoir combien de sourires on a
collecté depuis le début du niveau.
Comme première tentative, on peut simplement afficher ce chiffre sur la console à
chaque update de Gosu. Et quelle classe sera la mieux placée pour connaitre
le nombre de sourires collectés pendant le niveau actuel ? La classe `Level`
bien entendu. Il nous faut deux nouvelles méthodes, `collected` qui retourne le
nombre de sourires collectés jusqu'à présent et `collect`, qui incrémente le
nombre de sourires collectés :

```ruby
class Level
  attr_reader :collected

  def initialize
    @levels = YAML.load_file('levels.yaml')
    @collected = 0
  end

  # ...

  def collect
    @collected += 1
  end
end
```

La classe Player a maintenant besoin de pouvoir parler à l'objet de type Level
pour lui passer le message `collect` :

```ruby
class Player
  # ...

  def initialize(level)
    # ...
    @level = level
  end

  def collision(type)
    case type
    when :smiley_up
      # ...
      @level.collect # <------- Un sourire collecté !
    end
    # ...
  end
end
```

Le code qui précède est quelque chose que je n'aime pas faire. `Player` a
désormais connaissance d'un objet de type `Level` et peut faire ce qu'il veut
avec. Même si aujourd'hui je *sais* qu'il ne faut rien faire d'autre que
`@level.collect`, dans 6 mois ça sera une toute autre histoire. J'aurais oublié
tout ça et quand je verrai cet objet `@level` je penserai sûrement que je peux
faire ce que je veux avec (*c'est à dire modifier tout et n'importe quoi*). Et
tout ce que ça pourra produire, c'est un maximum de confusion.

Il y a plusieurs façons de gérer ça et on va en examiner quelques unes dans un
petit moment. Mais terminons d'abord ce que nous étions en train de faire,
c'est à dire l'affichage du nombre de sourires collectés :

```ruby
class Window < Gosu::Window

  def initialize(width, height)
    # ...
    @level = Level.new
    @player = Player.new(@level)
    # ...
  end

  def update
    # ...
    puts @level.collected # <--- On log sur la console pour vérifier
  end
```

Si vous lancer le jeu vous verrez le nombre d'objet collectés qui s'affiche à chaque
update de Gosu.

Maintenant parlons de quelques méthodes possibles pour éviter de se trainer un
objet de type `Level` dans la classe `Player`.

1. On pourrait se contenter de mettre un commentaire, encore faudra-t-il le
  voir, le lire et le maintenir.
2. On pourrait utiliser un [observer](https://en.wikipedia.org/wiki/Observer_pattern), mais je trouve ça un peu trop,
   vu que l'on n'a qu'un seul évènement à déclencher.
3. J'imagine qu'on pourrait aussi utiliser un [mediator](https://en.wikipedia.org/wiki/Mediator_pattern) entre les classes
   `Player` et `Level`. Mais là encore je trouve ça trop avec seulement deux
   classes.

Alors quoi ? Un [proxy](https://en.wikipedia.org/wiki/Proxy_pattern) qui sera restreint à la seule méthode `collect` :

```ruby collector_proxy.rb
class CollectorProxy

  def initialize(level)
    @level = level
  end

  def collect
    @level.collect
  end
end
```

```ruby
class Window < Gosu::Window

  def initialize(width, height)
    # ...
    @level = Level.new
    @player = Player.new(CollectorProxy.new(@level))
    # ...
```

De cette manière, un `Player` ne pourra rien faire d'autre qu'appeler la 
méthode `collect` sur ce fameux `@level`.

## Visualisation de l'état d'avancement du niveau

On va afficher le numéro du niveau en haut à droite, et une petite barre
d'avancement sous les pieds du joueur pour savoir où on en est dans la collecte
des sourires.

La majeure partie des modifications se situe dans la classe `UI`, n'hésitez pas
à remplacer les nombres magiques restants par des constantes :

```ruby
class UI
  Yellow = 0xff_ffff00

  # ...

  def draw(game)
    # ...
    draw_level(game[:level])
  end

  def draw_level(level)
    Gosu::draw_rect(0, 477, achieved_part(level), 3, Yellow, ZOrder::UI)

    @font.draw("Level: #{level[:number]}", 550, 10, ZOrder::UI, 1.0, 1.0,
               Yellow)
  end

  def achieved_part(level)
    WindowWidth / level[:goal] * level[:collected]
  end
end
```

Pour pouvoir utiliser le code précédent, il faut ajouter quelques informations
au *game state* :

```ruby
class Window < Gosu::Window
  def game_state
    {
      score: @player.score,
      lives: @player.lives,
      game_over: @game_over,
      level: {
        goal: @level.goal,
        number: @level.number,
        collected: @level.collected,
      },
    }
  end
end
```

Et pour tester tout de suite, on triche un peu avec les méthodes `Level#goal` et
`Level#number` pour qu'elles retourne toujours une même chose qu'on contrôle
bien :

```ruby
class Level
  def goal
    @levels.first['goal']
  end

  def number
    "1"
  end
end
```

Vous pouvez tester le jeu maintenant pour voir l'affichage du niveau et de
son état d'avancement.

## Des niveaux, enfin !

On veut maintenant les faire fonctionner, ces niveaux ! Le gros du travail se
passe dans la classe `Level`. Notamment avec les méthodes `song`, `goal` et
`number` qui doivent désormais retourner des informations pertinentes sur le
niveau actuel.

```ruby
class Level
  attr_reader :collected

  def initialize
    @levels = YAML.load_file('levels.yaml')
    @collected = 0
    @index = 0
  end

  def song
    current 'song'
  end

  def collect
    @collected += 1
  end

  def goal
    current 'goal'
  end

  def number
    @index + 1
  end

  def completed?
    @collected == goal
  end

  def next
    @index += 1
    @index %= @levels.size
    @collected = 0
  end

  private

  def current(property)
    @levels[@index][property]
  end
end
```

Dans la méthode `Level#next`, le modulo permet de boucler sur les niveaux. Pas
très réaliste, mais ça permet de différer la gestion de la fin du jeu
(il se passe quoi quand on a terminé tout les niveaux ?).

Voici le code pour passer au niveau suivant :

```ruby
class Window < Gosu::Window
  def update
    reset if new_game?
    next_level if @level.completed?
    # ...
  end

  private

  def next_level
    @items = []
    @level.next
    @song_player.play(@level.song)
  end
end
```

Il faut aussi s'assurer qu'une nouvelle partie débute bien sur le premier
niveau :

```ruby
class Window < Gosu::Window
  def reset
    @items = []
    @player.reset
    @level.reset # <----------------- C'est ici que ça se passe !
    @song_player.play(@level.song)
    @game_over = false
  end
end
```

```ruby
class Level
  def reset
    @collected = 0
    @index = 0
  end
end
```

Puis pour obtenir une transition moins abrupte entre les niveaux, on ajoute un
petit son :

```ruby
class Level
  def initialize
    # ...
    @sound_next_level = Gosu::Sample.new("assets/sound/next-level.wav")
  end

  def next
    # ...
    @sound_next_level.play
  end
end
```

Et voilà, nous avons maintenant des niveaux exploitables.
La prochaine fois nous étofferons ces niveaux, avec des bonus, des malus, etc.

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
    │   │   ├── Catch The Mystery.ogg
    │   │   └── In early time.ogg
    │   └── sound
    │       ├── collect.wav
    │       ├── life-lost.wav
    │       └── next-level.wav
    ├── button.rb
    ├── collector_proxy.rb
    ├── level.rb
    ├── levels.yaml
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── song_player.rb
    ├── ui.rb
    ├── window.rb
    └── z_order.rb

    6 directories, 24 files

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.8.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.8.0).

{% connexe %}
