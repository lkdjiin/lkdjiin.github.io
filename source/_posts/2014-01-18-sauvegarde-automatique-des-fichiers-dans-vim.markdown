---
layout: post
title: "Sauvegarde automatique des fichiers dans Vim"
date: 2014-01-18 09:45
comments: true
categories: [vim, débutant]
---

{% level 1 %}

Aujourd'hui je parle d'un petit truc qui me facilite
énormément la vie sous Vim: la sauvegarde automatique.

<!-- more -->

Grâce à ce truc, je n'enregistre pratiquement jamais
*intentionnellement* un fichier. Ce qui fait que je
n'oublie jamais de le faire. Vous savez ? : On modifie
un fichier, on lance l'appli et… arg… ça fonctionne pas !
Tout ça parce qu'on a oublié d'enregistrer les
modifications.

Donc pour enregistrer le fichier courant, la commande est:

``` vim
:w
```

Pour enregistrer tous les fichiers:

``` vim
:wall
```

Pour les accros du Ctrl-S, on peut le reproduire avec le mapping
suivant dans le `.vimrc`:

``` vim
map <C-s> :w<Enter>
```

**Et maintenant le truc promis**. Je veux que mes fichiers soient enregistrés
quand un onglet perds le focus, ou quand Vim lui-même perds le focus:

``` vim
autocmd FocusLost,TabLeave * :wall
```

Avec cette commande dans votre `.vimrc`, il est rare de devoir
enregistrer manuellement un fichier ;)

Et si vous voulez comprendre ce que fais exactement cette commande, je
vous laisse regarder l'aide:

``` vim
:h autocmd
:h FocusLost
:h TabLeave
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
