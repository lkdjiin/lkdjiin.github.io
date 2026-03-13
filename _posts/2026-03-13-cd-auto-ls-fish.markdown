---
layout: post
title: "Cd avec ls automatique dans Fish"
date: 2026-03-13 8:00
comments: true
tags: [ linux, fish ]
---

Afficher automatiquement le contenu du répertoire après la commande `cd`,
c'est cool non ?
Toutes les X années je me demande «Pourquoi j'ai arrêté d'utiliser ça ?»
Alors je le remet en place et au bout de quelques heures je le désinstalle.
C'est tout simplement pas pour moi.
Cette fois n'aura pas fait exception, mais c'est l'occasion de montrer la
programmation évenementielle dans un script Fish.

<!-- more -->


## Le problème

Une version Bash minimaliste serait la suivante :

{% highlight bash %}
# version Bash

function cd() {
  builtin cd "$*"
  ls
}
{% endhighlight %}

On a créé une fonction `cd` qui se substitue à la commande `cd` interne à Bash.
Dans cette fonction on utilise `builtin` pour appeller explicitement le `cd`
interne à Bash. Contrairement à beaucoup de commandes, `cd` n'est pas un
programme externe. Il est codé à l'interieur du shell, essentiellement parce
que `cd` doit manipuler le répertoire de travail.

Voici la même fonction, transformée pour Fish :

{% highlight bash %}
# version Fish

function cd
  builtin cd $argv
  ls
end
{% endhighlight %}

Et ça fonctionne bien, jusqu'à ce que vous essayiez `cd -` :

{% highlight bash %}
$ cd -
cd : Le dossier « - » n’existe pas
{% endhighlight %}

En fait dans Fish, `cd` est déjà un wrapper autour du `cd` interne. C'est ce wrapper qui fait fonctionner comme il
faut `cd -` — _il fait aussi un tas d'autres trucs, `type cd` si vous voulez voir le wrapper_ —.

## La solution

On pourrait s'aventurer à récrire le wrapper, mais il y a plus simple :
la programmation évenementielle. Je sais que ce n'est pas une chose qu'on
s'attend à trouver dans un shell, mais c'est bien présent :

{% highlight bash %}
function auto-ls-after-cd --on-variable PWD
  ls
end
{% endhighlight %}

La fonction `auto-ls-after-cd` sera appellée automatiquement chaque fois que la
variable `PWD` changera. Cette variable représente le répertoire de travail
(aussi appellé répertoire courant) et est mise à jour par le shell à chaque
changement de répertoire. Ce qui tombe bien ;)

En condition réelle j'aurais quelque chose de plus proche du code suivant :

{% highlight bash %}
# Dans le fichier config.fish

function auto-ls-after-cd --on-variable PWD
  if status is-interactive
    timeout 0.5s ls -lh --time-style=long-iso
  end
end
{% endhighlight %}
