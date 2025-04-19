---
layout: post
title: "Jetpack Hero"
date: 2025-04-19 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

C'est la toute première partie d'une série consacrée à l'écriture d'un jeu avec
DragonRuby.

<!-- more -->

## DragonRuby en quelques mots

C'est un moteur de jeu 2D, payant, basé sur [mruby](https://mruby.org/) et la [SDL](https://www.libsdl.org/).
Vous le trouverez [ici](https://dragonruby.itch.io/dragonruby-gtk). Il n'y a pas d'installation, un zip
est fourni avec tout le nécessaire.
J'utiliserai la dernière version du 20 mars 2025.
Une fois le zip décompressé et le dossier renommé en jetpack-hero on peut commencer.

## Création du personnage

Je m'inspire _très fortement_ (et c'est peu dire :D) du jeu
[H.E.R.O de l'atari 2600](https://en.wikipedia.org/wiki/H.E.R.O._(video_game)) pour pondre ceci :

{% img center /images/jetpack-hero-1.png %}

Le fichier original fait 7x17 pixels.

## Affichage

L'image à afficher est décrite dans un hash.`x` et `y` sont les positions du
coin inférieur gauche (l'écran mesure 1280x720, on ne peut pas le modifier, et l'origine 0,0 se situe en bas à gauche).
`w` et `h` sont respectivement la largeur et la hauteur de l'image affichée. Ici
j'étire l'image originale d'un facteur 4.

Tout se passe dans la méthode `tick` qui est appelée 60 fois par seconde.
Le paramètre `args` est notre moyen de communiquer avec le moteur de jeu, on
pourra aussi y stocker ce qu'on veut.
Pour dessiner un fond noir, j'ajoute un hash à `args.outputs.solids` qui décrit un rectangle de la taille de l'écran (x, y, w, h)
et de couleur noire (r, g, b).
Finalement j'affiche le personnage en ajoutant le hash `hero` à `args.outputs.sprites`.

{% highlight ruby %}
# Fichier mygame/app/main.rb

HERO_SCALE = 4

def tick args
  hero = {
    x: 600,
    y: 40,
    w: 7 * HERO_SCALE,
    h: 17 * HERO_SCALE,
    path: 'sprites/hero.png'
  }

  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0 }
  args.outputs.sprites << hero
end
{% endhighlight %}

Pour lancer le jeu il suffit d'appeler l'executable à la racine du dossier :

    $ ./dragonruby

## L'idiome ||=

La création du hash contenant les infos du personnage est répétée 60 fois par
seconde. Pour éviter cette situation, l'idiome `||=` est partout présent dans DragonRuby.
Au lieu d'une affectation sans condition comme celle-ci :

{% highlight ruby %}
def tick args
  hero = { ... }
end
{% endhighlight %}

on utilisera `||=` qui créera le hash seulement si celui-ci n'existe pas. Donc
uniquement durant la première itération de `tick`. Et on l'enregistrera dans
`args.state`, pour le sauvegarder entre les différents appels de `tick` :

{% highlight ruby %}
def tick args
  args.state.hero ||= { ... }
end
{% endhighlight %}

## Déplacements

`args.inputs` permet de tester les méthodes `left`, `right`, `up` et `down`.
Ces méthodes indiquent si on appuie sur une touche fléchée, sur "QSDZ" en azerty, ou sur la croix directionnelle d'une manette.

Notez qu'on peut accéder à un élément d'un hash avec la notation `hash.key`, comme par
exemple dans `args.state.hero.x`.

{% highlight ruby %}
HERO_SCALE = 4

def tick args
  args.state.hero ||= {
    x: 600,
    y: 40,
    w: 7 * HERO_SCALE,
    h: 17 * HERO_SCALE,
    path: 'sprites/hero.png'
  }

  if args.inputs.left
    args.state.hero.x -= 5
  elsif args.inputs.right
    args.state.hero.x += 5
  end

  if args.inputs.up
    args.state.hero.y += 5
  elsif args.inputs.down
    args.state.hero.y -= 5
  end

  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0 }
  args.outputs.sprites << args.state.hero
end
{% endhighlight %}

Et en quelques lignes, notre personnage se déplace sur l'écran à l'aide du clavier ou
d'une manette de jeu.

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [DragonRuby](https://dragonruby.itch.io/dragonruby-gtk)
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby
