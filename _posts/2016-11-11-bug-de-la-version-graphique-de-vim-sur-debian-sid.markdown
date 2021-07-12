---
layout: post
title: "Bug de la version graphique de Vim sur Debian Sid"
date: 2016-11-11 09:46
legacy: true
tags: [vim, debian, gtk, gtk3, bug, update-alternatives]
---

Depuis une mise à jour récente de la bibliothèque gtk3 un
bug affecte la version graphique de Vim (`gvim`) sur Debian Sid. Ce bug est
important puisqu'il rend `gvim` tout simplement inutilisable. Lorsqu'on lance
le programme on obtient le message suivant, qui se répète plusieurs fois :

    $ gvim

    (gvim:6054): Gtk-CRITICAL **: gtk_widget_set_size_request: assertion 'width >= -1' failed
    *** BUG ***
    In pixman_region32_init_rect: Invalid rectangle passed
    Set a breakpoint on '_pixman_log_error' to debug
    .
    .
    .

Des discussions sont en cours pour savoir si le bug est de la responsabilité
de Vim ou de Gtk3, mais en attendant on fait quoi ?

<!-- more -->

On peut d'abord regarder où est placée la commande `gvim` :

{% highlight bash %}
$ which gvim
/usr/bin/gvim
{% endhighlight %}

On peut maintenant regarder quel programme est en réalité appelé par cette
commande (j'ai tronqué la sortie pour laisser seulement ce qui est
intéressant).  On voit que `gvim` est un lien symbolique qui pointe sur
`/etc/alternatives/gvim` :

{% highlight bash %}
$ ls -l /usr/bin/gvim
[...] /usr/bin/gvim -> /etc/alternatives/gvim*
{% endhighlight %}

Allons voir sur quel programme est *branché* l'alternative :

{% highlight bash %}
$ ls -l /etc/alternatives/gvim
[...] /etc/alternatives/gvim -> /usr/bin/vim.gtk3*
{% endhighlight %}

Ça fait sens. Regardons quelles *versions* de vim sont disponibles en tapant
`vim` + tab :

{% highlight bash %}
$ vim
vim        vim.basic  vimdiff    vim.gtk    vim.gtk3   vim.tiny   vimtutor 
{% endhighlight %}

L'ancienne version (`vim.gtk`) m'intéresse. Si vous ne l'avez pas/plus, vous
pouvez l'installer avec `apt-get install vim-gtk`.

## Solution n°1

Un tour dans l'aide de `vim.gtk` montrera qu'on peut le lancer avec l'option `-g`
pour avoir l'interface graphique. En attendant que le bug soit réparé on peut
donc utiliser `vim.gtk -g` à la place de `gvim`.

## Solution n°2

Le programme `update-alternatives` permet de gérer ce genre de problème
facilement. Utilisez le pour choisir ce que lancera la commande `gvim` :

    $ sudo update-alternatives --config gvim
    [sudo] Mot de passe de xavier : 
    Il existe 2 choix pour l'alternative gvim (qui fournit /usr/bin/gvim).

      Sélection   Chemin             Priorité  État
    ------------------------------------------------------------
    * 0            /usr/bin/vim.gtk3   50        mode automatique
      1            /usr/bin/vim.gtk    50        mode manuel
      2            /usr/bin/vim.gtk3   50        mode manuel

    Appuyez sur <Entrée> pour conserver la valeur par défaut[*] ou choisissez le numéro sélectionné :1

Vous pourriez préférer la version graphique `galternatives`.


