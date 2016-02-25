---
layout: post
title: "Écrire un jeu en 2d avec Ruby et Gosu - partie 3"
date: 2016-02-12 09:49
comments: true
categories: [ruby, gosu, jeu, 2d]
---

On continue notre jeu en 2d en comptabilisant et en affichant le score.
Au passage on voit aussi comment utiliser une fonte précise et comment jouer
un son.

{% img center /images/gosu4.png %}

<!-- more -->

La totalité des articles:

1. [Installation de Gosu, affichage d'images statiques](/blog/2016/02/10/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-1/)
2. [Déplacer le joueur et pluie de smileys](/blog/2016/02/11/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-2/)
3. Beep, fonte et collecte des smileys
4. [On s'occupe des vies](/blog/2016/02/13/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-4/)
5. [Musique et game over](/blog/2016/02/15/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-5/)
6. [Affichage selon un angle](/blog/2016/02/25/ecrire-un-jeu-en-2d-avec-ruby-et-gosu-partie-6/)

## Beep et collecte

Pour donner l'illusion que le joueur attrape un smiley, dès que les deux images
entre en collision on supprime le smiley et on joue un petit son. Le cœur de
la fonctionnalité se passera au sein de la méthode `Player#collect`, qu'on
déclenchera depuis la classe Window:

```ruby window.rb
class Window < Gosu::Window

  def update_player
    # ...
    @player.collect(@items)
  end

end
```

Voici ce qui change dans la classe Player. On en discute après:

```ruby player.rb
class Player

  # ...
  DistanceOfCollision = 35

  def initialize
    # ...
    @sound_collect = Gosu::Sample.new("assets/sound/collect.wav")
  end

  # ...

  def collect(items)
    items.reject! {|item| collide?(item) ? collision : false }
  end

  private

  def collide?(item)
    distance = Gosu::distance(x_center_of_mass, y_center_of_mass,
                              item.x_center_of_mass, item.y_center_of_mass)
    distance < DistanceOfCollision
  end

  def x_center_of_mass
    @x + @image.width / 2
  end

  def y_center_of_mass
    Y + @image.height / 4
  end

  def collision
    @sound_collect.play(1.0)
    true
  end
end
```

Tout d'abord, on charge un son comme on charge une image, sauf qu'on utilise
`Sample` au lieu de `Image`:

```ruby
    @sound_collect = Gosu::Sample.new("assets/sound/collect.wav")
```

Ensuite, la méthode `collect`. On doit trouver le ou les objets (si il y en a)
qui sont en collision avec le joueur. On teste justement cette éventuelle
collision avec un smiley avec la méthode `collide?`. Si collision il y a,
l'objet sera supprimé (voir `collision` plus loin):

```ruby
  def collect(items)
    items.reject! {|item| collide?(item) ? collision : false }
  end
```

> Modifier un objet sans vraiment le dire, par effet de bord, par exemple avec
> `reject!` comme ci-dessus ne manquera pas de remplir d'horreur les tenants de la
> programmation fonctionnelle. Mais comme le paradigme ici est la programmation
> orienté objet, je ne vois pas de problèmes ;)

Pour détecter si il y a eu collision entre deux objets, il existe plusieurs
méthodes. Comme Gosu fournit une méthode pour connaître la distance entre deux
points (`Gosu::distance`), voici ce que nous allons faire: le joueur et les smileys vont être
chacun représentés par un seul point précis. Si la distance entre ses deux points
tombe sous un certain seuil, nous considèrerons qu'il y a collision.

Le joueur est représenté par le point (`x_center_of_mass`, `y_center_of_mass`)
et un smiley par le point (`item.x_center_of_mass`, `item.y_center_of_mass`):


```ruby
  def collide?(item)
    distance = Gosu::distance(x_center_of_mass, y_center_of_mass,
                              item.x_center_of_mass, item.y_center_of_mass)
    distance < DistanceOfCollision
  end
```

Pour le joueur, la coordonnée x utilisée pour la détection de collision est
pile au milieu:

```ruby
  def x_center_of_mass
    @x + @image.width / 2
  end
```

Pour la coordonnée y, c'est le quart en partant du haut:

```ruby
  def y_center_of_mass
    Y + @image.height / 4
  end
```

Enfin, lors d'une collision il faut émettre un son et retourner `true` pour que
`reject!` sache qu'il faut supprimer ce smiley de la collection. Le paramètre
de `play` est le volume, de 0.0 à 1.0:

```ruby
  def collision
    @sound_collect.play(1.0)
    true
  end
```

Le point d'un smiley utilisé pour détecter une collision est le milieu de
la largeur pour x et le haut pour y:

```ruby smiley.rb
class Smiley
  attr_reader :x, :y

  # ...

  def x_center_of_mass
    @x + @image.width / 2
  end

  def y_center_of_mass
    @y
  end

end
```

N'hésitez pas à modifier ces points de détection ainsi que la constante
`DistanceOfCollision` pour trouver les valeurs qui vous conviennent.

## Compter et afficher les points

On va ajouter 10 points quelque soit le type de smiley collecté. Et on va
afficher le score dans le coin supérieur gauche. Les sorties informatives
telles que le score, les vies, etc, seront gérées depuis la classe `UI`:

```ruby main.rb
# ...
require_relative 'z_order'
require_relative 'player'
require_relative 'smiley'
require_relative 'ui'
require_relative 'window'
# ...
```

Un pattern commence à se dessiner, on crée un objet dans l'initialisation de
`Window` et on appelle sa méthode `draw`:

```ruby window.rb
class Window < Gosu::Window

  def initialize(width, height)
    # ...
    @ui = UI.new
    # ...
  end

  def draw
    # ...
    @ui.draw(score: @player.score)
  end

end
```

Les sorties de l'UI doivent être toujours visibles, on leurs donnera donc le
ZOrder le plus grand:

```ruby z_order.rb
module ZOrder

  Background = 0
  Items      = 1
  Player     = 2
  UI         = 3

end
```

La classe Player est un bon endroit pour tenir compte du score et le mettre à
jour lors d'une collision avec un smiley:

```ruby player.rb
class Player
  # ...

  attr_reader :score

  def initialize
    # ...
    @score = 0
  end

  def collision
    @score += 10
    # ...
  end

end
```

Finalement voici un peu de nouveauté avec la classe UI et l'utilisation d'une
fonte pour afficher du texte.  Pour info, j'ai trouvé la police
`VT323-Regular.ttf` sur Google Font.  Le chargement d'une police de caractères
nécessite de fournir la taille et le fichier de la police:


```ruby ui.rb
class UI

  def initialize
    @font = Gosu::Font.new(20, name: "assets/fonts/VT323/VT323-Regular.ttf")
  end

  def draw(score:)
    @font.draw("Score: #{score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end

end
```

Quant à la méthode `draw` d'une fonte, je vous invite à regarder
[sa documentation](https://www.libgosu.org/rdoc/Gosu/Font.html#draw-instance_method)
pour connaître les paramètres à fournir.

Une explication toutefois, ceci:

    0xff_ffff00

…est une couleur au format alpha, rouge, vert, bleu en hexadécimal. Le
*underscore* est juste une fonctionnalité de Ruby qui permet d'écrire les nombres
avec des underscores pour faciliter la lecture. Par exemple les deux nombres
qui suivent sont identiques, lequel est le plus simple à lire ?

    1000000000

    1_000_000_000

Et ça marche pareil avec l'hexadécimal.

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
    │   │   ├── player.png
    │   │   ├── smiley-green.png
    │   │   └── smiley-yellow.png
    │   └── sound
    │       └── collect.wav
    ├── main.rb
    ├── player.rb
    ├── smiley.rb
    ├── ui.rb
    ├── window.rb
    └── z_order.rb

Le code et les assets se trouvent [sur Github](https://github.com/lkdjiin/collect-the-smiles).
La version précise pour cet article est la [version 0.3.0](https://github.com/lkdjiin/collect-the-smiles/releases/tag/v0.3.0).

{% connexe %}
