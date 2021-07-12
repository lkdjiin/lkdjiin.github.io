---
layout: post
title: "Le jeu de la vie en logo - partie 2"
date: 2014-12-17 16:35
legacy: true
tags: [jeu de la vie, logo]
---



Cette fois, on affiche la génération de cellules crée la dernière fois.
J'ai déjà eu l'occasion de dire que Logo était spécial, on va voir avec
son système graphique que c'est bien le cas. Je ne vais pas parler de la
métaphore de la *tortue*, vous trouverez sûrement des ressources là-dessus.
Je voudrais plutôt parler du système de coordonnée. Alors que dans la plupart des
langages (tous ?) les systèmes graphiques proposent de placer le point d'origine (0, 0) en haut à
gauche, Logo le place au centre. En général, l'axe des y croit vers le bas,
en Logo il croit vers le haut.

Selon le manuel d'UCBLogo, voici à quoi s'attendre:

    (-100, 100)            (100, 100)

                  (0, 0)

    (-100, -100)           (100, -100)

<!-- more -->

Mais en fait, non. J'ai plutôt ça sur la machine où j'utilise Logo:


    (-250, 250)            (250, 250)

                  (0, 0)

    (-250, -250)           (250, -250)

Quoiqu'il en soit, voici comment ça marche.

{% highlight raw %}
hideturtle

to draw.generation :generation :size
for [y 1 :size] [p.draw.line :y]
end

to p.draw.line :y
for [x 1 :size] [if (cell.alive? :generation :x :y) [p.draw.cell :x :y ] ]
end

to p.draw.cell :x :y
penup
setxy :x :y
setheading 90
pendown
forward 1
end
{% endhighlight %}

`hideturtle` cache la tortue, comme son nom l'indique. Parce que, en plus
d'être moche, ça ralenti le dessin, qui n'est déjà pas très rapide.

La procédure `draw.generation` itère sur chaque ligne de `generation` et
appelle la procédure *privée* `p.draw.line`.

`p.draw.line` itère sur chaque cellule de la ligne. On détermine, avec
`cell.alive?`, si la cellule est vivante. Si c'est le cas, on appelle
`p.draw.cell`.

`p.draw.cell` affiche un pixel en (x, y).

Dans le fichier `generation.lg`, j'ajoute la procédure `cell.alive?`.

{% highlight raw %}
to cell.alive? :generation :x :y
localmake "line item :y :generation
ifelse (item :x :line) = 1 [output "true] [output "false]
end
{% endhighlight %}

Puis on assemble le tout dans un fichier `application.lg`.

{% highlight raw %}
load "generation.lg
load "drawing.lg

make "size 100

draw.generation create.generation :size :size :size
{% endhighlight %}

Et voici le résultat:

    $ tree
    .
    ├── application.lg
    ├── drawing.lg
    ├── generation.lg
    └── test.generation.lg

    $ logo application.lg

{% img /images/game-of-life-logo.png %}

Mouais, un peu moche, non ? J'avoue que je commence déjà à en avoir marre de
Logo.




