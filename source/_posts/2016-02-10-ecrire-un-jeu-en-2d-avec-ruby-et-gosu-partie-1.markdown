---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 1"
date: 2016-02-10 10:44
comments: true
categories: [ruby, gosu, jeu, 2d]
---

Voici une série d'articles sur l'écriture d'un jeu en 2d avec Ruby et Gosu.
Dans ce premier article on verra comment installer Gosu, créer une
fenêtre et afficher des images statiques les unes au dessus des autres.

{% img center /images/gosu0.png %}

<!-- more -->

La totalité des articles:

1. Installation de Gosu, affichage d'images statiques
2. [Déplacer le joueur et pluie de smileys](/blog/2016/02/11/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-2/)
3. [Beep, fonte et collecte des smileys](/blog/2016/02/12/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-3/)
4. [On s'occupe des vies](/blog/2016/02/13/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-4/)
5. [Musique et game over](/blog/2016/02/15/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-5/)
6. [Affichage selon un angle](/blog/2016/02/25/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-6/)
7. [Plusieurs musiques et reset de la partie](/blog/2016/05/01/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-7/)

## Les outils

Avant d'écrire la première ligne de code, assurez vous d'avoir installé correctement Ruby et la
gem Gosu.

### Ruby

J'utiliserai Ruby en version 2.3 (la plus récente à ce jour). Si vous
utilisez une version de Ruby plus ancienne, vous devrez peut-être adapter le
code ici ou là. Pour gérer les différentes version de Ruby, j'utilise
indifféremment [rvm](https://rvm.io/) ou
[chruby](https://github.com/postmodern/chruby)
*— mais pas les deux sur la même machine, hein ;) —*.

> Si vous n'avez jamais utilisé de gestionnaire de version pour Ruby, je
> conseille de commencer par **chruby**. Si je préfère personnellement
> **rvm** que je trouve plus complet, **chruby** s'avère
> indéniablement plus simple à installer, à prendre en main, et à utiliser sur le
> long terme.

### Gosu

Gosu est la gem qui nous fournira les méthodes basiques pour développer notre
jeu. J'ai installé la dernière version en date : gosu 0.10.5.

Sur **Debian** il faut d'abord s'assurer qu'on dispose des packages suivants:

    sudo apt-get install build-essential libsdl2-dev libsdl2-ttf-dev \
                         libpango1.0-dev libgl1-mesa-dev libfreeimage-dev \
                         libopenal-dev libsndfile1-dev

Et ensuite seulement on peut installer la gem Gosu:

    gem install gosu

Vous pouvez installer Gosu sur d'autres versions de Linux, sur OS X, ou sur
Windows:

- [Installation sur Linux](https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux)
- [Installation sur OS X](https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X)
- [Installation sur Windows](https://github.com/gosu/gosu/wiki/Getting-Started-on-Windows)

Enfin, vous pourrez trouver de l'aide sur [le wiki](https://github.com/gosu/gosu/wiki)
et [la documentation de Gosu](https://www.libgosu.org/rdoc/) pour le langage Ruby.

## Du son, des images, etc

Dans cette série d'articles nous allons coder un jeu. Pour ce qui est du son
et des images, on va laisser faire les gens qui savent ;) Mes deux sources
préférées pour les assets open source sont [freesound.org](http://freesound.org/browse/)
et [opengameart.org](http://opengameart.org/).

J'utilise **Gimp** pour retoucher les images : découpe, mise à l'échelle,
changement de couleur, etc. Et j'utilise **Audacity** pour retravailler les
fichiers sonores : suppression des silences en début de fichier, conversion de
format (par exemple mp3 en ogg puisque Gosu ne lit pas le mp3).

## Créer une fenêtre pour le jeu

Ça y est ! Ruby et Gosu sont installés, vous savez où trouver des images et du
son open source, on peut commencer en créant une fenêtre. Mettez le code
suivant dans un fichier `window.rb`:

```ruby window.rb
require 'gosu'

class Window < Gosu::Window

  def initialize
    super(640, 480)
    self.caption = "Collect The Smile!"
  end

end

window = Window.new
window.show
```

Le code est suffisamment simple pour que vous puissiez le comprendre sans
explications superflues. Pour savoir si vous avez bien installé Gosu, lancez
le programme:

    $ ruby window.rb

Et admirez le résultat:

{% img center /images/gosu1.png %}

Même avec si peu de code, on peut déjà refactorer. Le fichier précédent
a deux problèmes. Un, il mélange la définition d'une classe et le lancement du
jeu. Et deux, il utilise deux nombres magiques. Si on n'y prends pas garde, les
nombres magiques vont vite devenir un fléau pour notre jeu. Les jeux ont tendance
à être saturés de nombres magiques, alors autant s'atteler à ce problème dès le début.

Après refactoring,
nous avons donc d'une part le code de lancement, avec des constantes pour les
dimensions.  On n'a plus à deviner ce que représente les nombres 640 et 480,
c'est inscrit dans le code:

```ruby main.rb
require 'gosu'

require_relative 'window'

WindowWidth  = 640
WindowHeight = 480

window = Window.new(WindowWidth, WindowHeight)
window.show
```

Et d'autre part la classe `Window`, tranquille dans son propre fichier:

```ruby window.rb
class Window < Gosu::Window

  def initialize(width, height)
    super
    self.caption = "Collect The Smile!"
  end

end
```

La structure du dossier est pour l'instant la suivante:

    $ tree
    .
    ├── window.rb
    └── main.rb

Et nous lancerons donc le jeu avec la commande `ruby main.rb`.

## Afficher des images

Maintenant qu'on sait créer une fenêtre, l'étape suivante sera l'affichage
d'images statiques. Nous allons afficher une image de fond, et par-dessus
l'image du joueur.

Toutes les images du jeu seront rangées dans le dossier `assets/images`:

    $ tree
    .
    ├── assets
    │   └── images
    │       ├── background.png
    │       └── player.png
    ├── window.rb
    └── main.rb

```ruby window.rb
class Window < Gosu::Window

  def initialize(width, height)
    super
    self.caption = "Collect The Smile!"

    @background_image = Gosu::Image.new("assets/images/background.png")
    @player_image = Gosu::Image.new("assets/images/player.png")
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player_image.draw(width / 2, height / 2, 1)
  end

end
```

Pendant l'initialisation on charge les images en mémoire avec
`Gosu::Image.new`.  Puis l'affichage se fait avec **les** méthodes `draw`. La
méthode `draw` de la classe `Window` est hérité de `Gosu::Window` et appelée 60
fois par seconde.  Dans cette méthode, on appelle la méthode `draw` des images.
Celle-ci prends trois paramètres : les coordonnées **x**, **y** et **z**.
La coordonnée z est le plan d'affichage. Au dessus ou en dessous. Plus le
nombre est haut, plus l'image sera affichée au-dessus des autres. Ici l'image
de fond a un z de 0, et l'image du joueur a un z de 1, donc le joueur est
affiché au-dessus du fond.

Le joueur est affiché *à peu près* au milieu de la surface de jeu (`width / 2`
et `height / 2`). À peu près, puisque les paramètres x et y de la méthode
`draw` définissent les coordonnées du coin supérieur gauche de l'image.

{% img center /images/gosu2.png %}

Ce code souffre lui aussi de certains problèmes.

1. S'il est acceptable que l'image de fond *appartienne* à la fenêtre de jeu,
   c'est absurde en ce qui concerne l'image du joueur.
2. Il y a des nouveaux nombres magiques : les coordonnées z.

On va donc créer deux nouvelles classes (en fait une classe et un module),
`ZOrder` et `Player`:

```ruby main.rb
require 'gosu'

require_relative 'z_order'
require_relative 'player'
require_relative 'window'

WindowWidth  = 640
WindowHeight = 480

window = Window.new(WindowWidth, WindowHeight)
window.show
```

Le contenu du module `ZOrder` est simpliste (c'est ni plus ni moins qu'un enum),
il définit les différents plans:

```ruby z_order.rb
module ZOrder

  Background = 0
  Player     = 1

end
```

La classe `Player` est simple elle aussi.

> C'est l'avantage écrasant d'éclater le code en petites classes ayant chacune
> une seule responsabilité : le code devient simplissime.

L'image *appartient* désormais au joueur, tout comme ses coordonnées. Et c'est
le joueur lui-même qui *sait* comment s'afficher. La classe `Window` aura
juste à déclencher cet affichage.

```ruby player.rb
class Player

  def initialize(x, y)
    @x = x
    @y = y
    @image = Gosu::Image.new("assets/images/player.png")
  end

  def draw
    @image.draw(@x, @y, ZOrder::Player)
  end

end
```

```ruby window.rb
class Window < Gosu::Window

  def initialize(width, height)
    super
    self.caption = "Collect The Smile!"

    @background_image = Gosu::Image.new("assets/images/background.png")

    @player = Player.new(width / 2, height / 2)
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
  end

end
```

Pour finir, voici le contenu du jeu pour l'instant:

    $ tree
    .
    ├── assets
    │   └── images
    │       ├── background.png
    │       └── player.png
    ├── main.rb
    ├── player.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.1.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.1.0).

{% connexe %}
