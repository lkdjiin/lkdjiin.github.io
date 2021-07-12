---
layout: post
title: "Raccourcis clavier pour le terminal"
date: 2014-01-17 21:06
legacy: true
tags:
---



Aujourd'hui je parle des raccourcis clavier du terminal. Pas tous, il y
en a des tonnes, seulement ceux que j'utilise régulièrement.

<!-- more -->

Linux et OS X
-------------

Les raccourcis qui suivent fonctionnent aussi bien sous Linux et
OS X:

    Crtl-a   Aller en début de ligne
    Crtl-e   Aller en fin de ligne
    Crtl-k   Supprimer du curseur à la fin de la ligne
    Crtl-u   Supprimer avant le curseur
    Crtl-w   Supprimer le mot avant le curseur
    Crtl-t   Échanger les 2 caractères avant le curseur
    Esc-t    Échanger les 2 mots avant le curseur

Pour voir la liste de tous les mappings:

{% highlight bash %}
bind -P
{% endhighlight %}

Linux seulement
---------------

    Shift-Ctrl-c  Copier le texte sélectionné
    Shift-Ctrl-v  Coller le texte

OS X seulement
--------------

    Meta-c        Copier le texte sélectionné
    Meta-v        Coller le texte

En bonus, voici un truc très pratique sous OS X, qu'un collègue
([@julienXX](https://twitter.com/julienXX)) m'a
montré la semaine dernière: Un triple clic sur une ligne la sélectionne en
entier, avec le caractère de fin de ligne mais sans le prompt. On peut ensuite
faire un copier/coller avec `Shift-Meta-v`, ce qui lance la commande
directement.



À demain.


