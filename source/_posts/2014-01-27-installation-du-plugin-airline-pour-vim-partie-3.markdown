---
layout: post
title: "Installation du plugin Airline pour Vim - partie 3"
date: 2014-01-27 21:01
comments: true
categories: [vim, intermédiaire, plugin, airline, barre de statut]
---

{% level 2 %}

Maintenant qu'on a personnalisé l'apparence de Airline, voyons
comment on peut personnaliser les informations des sections.

<!-- more -->

Tout d'abord, la section qui affiche le numéro de ligne et de
colonne du curseur (la section la plus à droite) ne me plait pas
du tout. Je voudrais supprimer le petit symbole (qui prend de la
place pour rien) et le pourcentage (dont je n'ai jamais compris
l'intérêt) et ajouter le nombre de lignes du fichier. Je voudrais
donc un truc comme ça:

    ligne courante / total lignes : colonne

La documentation de Airline (`:h airline`) nous apprends que chaque
section possède un petit nom (pour la dernière c'est `z`), est
personnalisable, et qu'on peut même en ajouter. La documentation de
Vim (`:h 'statusline'`) nous permet de savoir quoi mettre:

``` vim
let g:airline_section_z = ' %l / %L : %c '
```

Et voilà.

Sur le même principe, je veux modifier la section centrale, celle qui
affiche le nom du fichier. Par défaut, c'est le nom complet, avec son
chemin, qui est affiché. Comme je dispose déjà de cette information dans
la barre de titre de la fenêtre, je n'en ai pas besoin et le nom du
fichier sans son chemin me suffira:

``` vim
let g:airline_section_c = '%t %m'
```

`%t` est le nom du fichier et `%m` est la marque de modification
(le `[+]`).

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
