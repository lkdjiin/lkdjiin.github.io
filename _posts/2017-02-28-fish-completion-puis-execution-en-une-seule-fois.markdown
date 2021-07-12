---
layout: post
title: "Fish : complétion puis exécution en une seule fois"
date: 2017-02-28 14:46
legacy: true
tags: [fish, shell]
---

Voici une astuce pour le [shell Fish](https://fishshell.com/), qui vous
permettra de compléter une commande et de la lancer en même temps.

## Comportement par défaut : complétion puis exécution

Fish propose une complétion automatique au fur et à mesure que vous saisissez
une commande. Dans la capture d'écran qui suit, la partie en grisée n'a pas
été saisie, elle est seulement proposée par Fish.

{% img center /images/fish-shell-before-completion.png %}

<!-- more -->

Pour accepter la complétion proposée il faut utiliser le raccourci clavier `Ctrl+F`.
Le curseur se déplace à la fin de la ligne.

{% img center /images/fish-shell-after-completion.png %}

On peut alors appuyer sur la touche `Entrée` pour exécuter la commande.

## Et maintenant tout en un seul raccourci

La complétion automatique de Fish est vraiment très bonne. Mais ce comportement
en deux temps, `Ctrl+F` suivi de `Entrée`, m'a rapidement exaspéré. J'ai
donc voulu le réduire à un seul raccourci : `Ctrl+G`. Vous pouvez bien sûr choisir celui
qui vous plaira le plus (j'ai choisi `G` parce que ça me fait penser à **Go !**).

Il vous faut créer une fonction `fish_user_key_bindings`, ou bien lui ajouter le
code suivant si elle existe déjà. Placez là dans le fichier
`~/.config/fish/functions/fish_user_key_bindings.fish`.

{% highlight raw %}
function fish_user_key_bindings

    # Ctrl+g (Go!). Like Ctrl+f Enter in one go.
    bind \cg accept-autosuggestion execute

end
{% endhighlight %}

Voilà, ça n'est qu'une ligne de code mais je ne pourrais plus m'en passer.

Si vous aussi vous avez une astuce sur Fish, n'hésitez pas à la partager dans
un commentaire, et merci d'avance.


