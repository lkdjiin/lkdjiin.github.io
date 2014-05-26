---
layout: post
title: "Cherchez avec grep dans Vim"
date: 2014-05-26 21:03
comments: true
categories: [vim, débutant, grep, ack, ag]
---

{% level 1 %}

Comment cherchez un mot ou un *pattern* dans votre base de code sans
quitter Vim ? Voici une réponse.

<!-- more -->

La commande `:grep` fait appel au programme `grep` installé sur votre
machine. La ligne suivante va chercher dans ma base de code le texte
`TODO`:

```vim
:grep TODO */*.rb
```

Sauf que, peut-être, ça ne marche pas chez vous. Si c'est le cas, il y
a fort à parier que le répertoire courant de Vim est, non pas celui du
fichier actif, mais votre *home*. Pour en être sûr, vous pouvez afficher
le répertoire courant:

```vim
:pwd
```

Pour changer le répertoire courant et qu'il coincide avec celui du fichier
courant, le plus rapide est:

```vim
:set autochdir
```

Après, ça *devrait* marcher ;) Je vous invite à lire
[cette page](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file)
pour les histoires de dossier courant.

Personnellement, ce truc de répertoire courant m'a toujours pris la tête,
et je préfère utiliser un plugin comme [Ack.vim](https://github.com/mileszs/ack.vim) ou [Ag.vim](https://github.com/rking/ag.vim),
ou plus souvent encore, faire la recherche directement dans une console. Mais chacun
ses goûts ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

