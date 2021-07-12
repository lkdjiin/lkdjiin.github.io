---
layout: post
title: "Cherchez avec grep dans Vim"
date: 2014-05-26 21:03
legacy: true
tags: [vim, débutant, grep, ack, ag]
---



Comment cherchez un mot ou un *pattern* dans votre base de code sans
quitter Vim ? Voici une réponse.

<!-- more -->

La commande `:grep` fait appel au programme `grep` installé sur votre
machine. La ligne suivante va chercher dans ma base de code le texte
`TODO`:

{% highlight vim %}
:grep TODO */*.rb
{% endhighlight %}

Sauf que, peut-être, ça ne marche pas chez vous. Si c'est le cas, il y
a fort à parier que le répertoire courant de Vim est, non pas celui du
fichier actif, mais votre *home*. Pour en être sûr, vous pouvez afficher
le répertoire courant:

{% highlight vim %}
:pwd
{% endhighlight %}

Pour changer le répertoire courant et qu'il coincide avec celui du fichier
courant, le plus rapide est:

{% highlight vim %}
:set autochdir
{% endhighlight %}

Après, ça *devrait* marcher ;) Je vous invite à lire
[cette page](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file)
pour les histoires de dossier courant.

Personnellement, ce truc de répertoire courant m'a toujours pris la tête,
et je préfère utiliser un plugin comme [Ack.vim](https://github.com/mileszs/ack.vim) ou [Ag.vim](https://github.com/rking/ag.vim),
ou plus souvent encore, faire la recherche directement dans une console. Mais chacun
ses goûts ;)



À demain.



