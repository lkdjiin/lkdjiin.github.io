---
layout: post
title: "Une machine de Turing en Ruby - Une bande de données infinie"
date: 2015-02-05 18:13
legacy: true
tags: [ruby, débutant, turing]
---



Dans la définition d'une machine de Turing on trouve:

> Le ruban est supposé être de longueur infinie vers la gauche ou vers la droite, en d'autres termes la machine doit toujours avoir assez de longueur de ruban pour son exécution.
> — Wikipédia

C'était une grande limitation de l'implémentation de [ma machine de Turing](https://github.com/lkdjiin/turing_machine)
que d'avoir une bande de taille fixe. Avec la nouvelle version, cette limitation
est désormais levée.

{% img center /images/infinity.jpg %}

<!-- more -->

Permettre à la bande de grandir à l'infini (en théorie, hein, parce que en
pratique on est toujours limité par la mémoire de l'ordinateur) est finalement
très simple:

{% highlight ruby %}
module TuringMachine

  class Tape

    BLANK_SYMBOL = '0'

    def initialize(data = BLANK_SYMBOL)
      @symbols = data.scan(/./)
      @index = 0
    end

    [...]

    def shift_left
      if @index == 0
        @symbols.unshift(BLANK_SYMBOL)
      else
        @index -= 1
      end
    end

    def shift_right
      @symbols.push(BLANK_SYMBOL) if @index == @symbols.size - 1
      @index += 1
    end

    [...]
{% endhighlight %}

Voici quelques explications.

    @symbols = data.scan(/./)

Dans le constructeur, on se sert de `String#scan` pour construire un tableau
avec les données initiales de la bande. Par exemple:

{% highlight irb %}
>> "110".scan(/./)
#=>["1", "1", "0"]
{% endhighlight %}

    @index = 0

Dans le constructeur toujours, la position de la tête de lecture est
initialement à zéro.

    def shift_left
      if @index == 0
        @symbols.unshift(BLANK_SYMBOL)
      else
        @index -= 1
      end
    end

Lorsqu'on bouge la tête de lecture à gauche, nous avons deux cas possibles.
Soit la tête de lecture est déjà dans la position la plus à gauche
(`if @index == 0`) et dans ce cas il faut créer une nouvelle cellule en tête
du tableau:

{% highlight irb %}
>> ["1", "2"].unshift("0")
#=>["0", "1", "2"]
{% endhighlight %}

Soit la tête de lecture est dans une autre position, et il suffit de la décaler
d'un cran vers la gauche (`@index -= 1`).

    def shift_right
      @symbols.push(BLANK_SYMBOL) if @index == @symbols.size - 1
      @index += 1
    end

Lorsqu'on bouge la tête de lecture à droite, il faut ajouter une cellule à la
fin du tableau (`@symbols.push`) seulement si la tête de lecture est placée
toute à droite du tableau (`@index == @symbols.size - 1`).

Dans tous les cas, il faut déplacer la tête de lecture d'un cran à droite
(`@index += 1`).


