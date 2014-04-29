---
layout: post
title: "Insérer le contenu d'un fichier ou d'une commande shell dans Vim"
date: 2014-04-29 21:49
comments: true
categories: [vim, débutant, astuce]
---

{% level 1 %}

Pour insérer le contenu d'un fichier quelconque dans le buffer courant de
Vim, utilisez la commande `:r`:

<!-- more -->

Comme dans: `:r /mon/fichier/quelconque`.

C'est vraiment utile parfois, le problème est que le nom du fichier doit
être
absolu, ou doit commencer par le tilde (`~`). Ce qui dans certains cas
limite pas mal l'usage de cette commande.

Au fait, `r` est le petit nom de `read` :)

La version avec un point d'exclamation `:r!` est aussi très intéressante
puisqu'elle insère la sortie d'une commande shell. Par exemple, si je tape:

    :r! cal

Cela va insèrer le calendrier du mois dans cet article, comme ceci:

         Avril 2014
    di lu ma me je ve sa
           1  2  3  4  5
     6  7  8  9 10 11 12
    13 14 15 16 17 18 19
    20 21 22 23 24 25 26
    27 28 29 30

Mais là encore j'ai un souci. Ça ne fonctionne qu'avec des commandes shell
et automatiquement dans mon *home*. Je m'explique:

1. Si j'édite un fichier `~/dossier/fichier` et que je veuille insérer le
   contenu de `dossier`, je dois écrire `:r! ls ~/dossier`. Alors que
   j'aimerais écrire juste `:r! ls`.
2. J'aimerais bien pouvoir insérer avec `r` la sortie de mes tests Rspec,
   par exemple. Mais `:r! rspec ~/mon/fichier` ne fonctionne pas, `rspec`
   n'étant pas reconnu par Vim comme étant une commande.

Enfin, bref, si tu sais comment venir à bout de ses limitations, ton
commentaire m'intéresse. Sinon, il m'intéresse aussi ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

