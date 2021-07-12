---
layout: post
title: "Installation du plugin Airline pour Vim - partie 1"
date: 2014-01-25 18:34
legacy: true
tags: [vim]
---



Pour disposer de quelques informations dans la barre de statut,
j'utilisais jusqu'ici statline, qui me convenait assez bien, rien de
tape à l'œil. Et puis j'ai décidé d'essayer quelque chose de
plus coloré, histoire de voir si ça m'était utile.

<!-- more -->

Avant d'installer [Airline](https://github.com/bling/vim-airline),
il faut bien entendu retirer Powerline, ou Statline (je n'en connais pas
d'autres).

Comme j'utilise Pathogen pour gérer mes plugins, voici comment rapatrier
le code d'Airline:

    git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

La documentation est exhaustive et fournit 
[ici](https://github.com/bling/vim-airline#installation)
d'autres méthodes d'installation pour Vundle, NeoBundle et VAM. 

Avec Pathogen, ne pas oublier de générer la documentation, vous en
aurez besoin pour personnaliser l'apparence et les fonctionnalités
de Airline:

{% highlight vim %}
:Helptags
{% endhighlight %}

Un rapide coup d'œil à la documentation, justement, montre que la
personnalisation aux petits oignons va prendre un peu plus longtemps
que quelques minutes. Bref, on va devoir se manger de la doc…

À ce stade, c'est à dire en ayant seulement installé Airline et rien
configuré encore, ça fonctionne déja. Mais curieusement (du moins c'est
curieux à mes yeux) Airline est configuré par défaut pour n'apparaître que
lorsqu'une fenêtre est splittée. Pour l'avoir tout le temps, il faut ajouter
ceci dans le `.vimrc`:

{% highlight vim %}
set laststatus=2
{% endhighlight %}

La prochaine fois, je m'attaquerais à la modification du thème.



À demain.


