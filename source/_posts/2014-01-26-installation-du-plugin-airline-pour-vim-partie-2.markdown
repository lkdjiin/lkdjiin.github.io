---
layout: post
title: "Installation du plugin Airline pour Vim - partie 2"
date: 2014-01-26 16:03
comments: true
categories: [vim, intermédiaire, plugin, airline, barre de statut]
---

{% level 2 %}

Après [l'installation basique du plugin Airline](/blog/2014/01/25/installation-du-plugin-airline-pour-vim-partie-1/), voyons maintenant
comment modifier quelque peu le thème.

<!-- more -->

On peut visualiser les thèmes disponibles pour Airline
[sur cette page](https://github.com/bling/vim-airline/wiki/Screenshots).
J'ai choisi wombat pour l'instant, puisque je trouve que c'est celui
qui *colle* le mieux avec mon jeu de couleurs actuel. Voici ce qu'il
faut ajouter au `.vimrc` pour changer de thème:

``` vim
let g:airline_theme='wombat'
```

Si vous n'êtes pas sûr du nom pour le thème que vous avez choisi,
regardez le nom du fichier dans le dossier
`vim-airline/autoload/airline/themes`.

J'ai ensuite installé quelques polices de caractères patchées pour Powerline,
trouvées
[ici](https://github.com/Lokaltog/powerline-fonts), mais aucunes
ne m'a vraiment séduite. J'utilise la font `Inconsolata-g`, qui me
convient parfaitement, je ne vois donc pas de raison d'en changer.

Il faut maintenant paramétrer les symboles pour les bords des sections,
la branche git, les fichiers en lectures seules, etc. Mettez donc
ceci dans votre `.vimrc`:

``` vim
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
```

Comme il n'est pas certain que les symboles ci-dessus apparaissent dans
votre navigateur, en voici une version en image:

{% img /images/symboles-airline.png %}

La prochaine fois, on verra comment modifier une section.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
