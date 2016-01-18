---
layout: post
title: "Les arbres browniens - 2ème partie"
date: 2016-01-18 09:54
comments: true
categories: [ruby, jruby, brownian tree, arbre, mouvement brownien]
---

Dans [le dernier article](/blog/2016/01/17/les-arbres-browniens/), je présentais un code de base en JRuby
pour construire des arbres browniens. À partir de ce code de base on peut
tester plusieurs variations.

## Des couleurs au hasard

{% img center /images/brownian-tree51.png %}

Pour cela, quand on *gèle* une cellule on lui attribue au hasard une valeur
entre 1 et le nombre maximum de couleur (ici seulement deux).

<!-- more -->

```ruby
def move
  # [...]
      if has_neighbors?(cell)
        @cells[cell[0]][cell[1]] = frozen
  # [...]

def frozen
  rand(2) + 1
end

def update_board(g)
        # [...]
      if @cells[i][j] == 1
        g.setColor(Color::MAGENTA)
        g.fillRect(i * SCALE, j * SCALE, SCALE, SCALE)
      elsif @cells[i][j] == 2
        g.setColor(Color::GREEN)
        # [...]
```

## Une ligne entière de graines

{% img center /images/brownian-tree52.png %}

En plaçant une ligne de graine, au lieu d'une seule, on obtient quelque chose
qui ressemble plus à des arbres.

## Couleurs suivant le temps d'arrivée

{% img center /images/brownian-tree53.png %}

Par exemple cyan pour les 800 premières itérations, magenta pour les 600
suivantes, et vert pour les dernières.

```ruby
  def frozen
    if @iteration < 800
      1
    elsif @iteration < 1400
      2
    else
      3
    end
  end
```

## Mouvement biaisé

{% img center /images/brownian-tree55.png %}

Pour produire l'image ci-dessus les cellules *montent* plus souvent qu'elles ne
descendent.

```ruby
cell[1] + [-1, 0, 1, -1, -1].shuffle.first
```

## Et encore

On peut trouver encore des tas de variations, et les mélanger. Par exemple dans
l'image suivante la couleur d'une cellule dépend du nombre de ses voisines et
la longueur du mouvement des cellules suit, en gros, une
[distribution de Cauchy](https://en.wikipedia.org/wiki/Cauchy_distribution).

{% img center /images/brownian-tree56.png %}

Si vous pensez à d'autres variations possibles, n'hésitez pas à m'en faire part.

{% connexe %}

