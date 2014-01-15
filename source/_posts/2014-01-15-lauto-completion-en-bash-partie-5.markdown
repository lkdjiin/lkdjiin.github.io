---
layout: post
title: "L'auto-complétion en Bash - partie 5"
date: 2014-01-15 20:44
comments: true
categories: [bash, intermédiaire, unix, auto complétion]
---

{% level 2 %}

Cet article est la suite de:
[L'auto complétion programmable en bash: partie 4](http://lkdjiin.github.io/blog/2014/01/14/lauto-completion-programmable-en-bash-partie-4/).

Les bases de l'auto complétion programmable
-------------------------------------------

Une application peut proposer ses services d'auto complétion en déposant
un fichier bash dans le dossier `/etc/bash_completion.d/`. 
On y voit un tas de fichiers, pour des programmes bien connus:

    [~]⇒ ls /etc/bash_completion.d/
    abook
    ant
    apache2.2-common
    apache2ctl
    apt
    ...
    git
    ...

Il suffit juste de savoir quoi mettre dedans. Allons-y:

<!-- more -->

``` bash /etc/bash_completion.d/mytool
complete -W "new compile test" mytool
```

Le fichier sera chargé automatiquement au lancement de bash. Donc pour que
ça fonctionne maintenant, soit vous le sourcez, soit vous lancez une
nouvelle console et, - *roulements de tambours*-

    [~]⇒ mytool [TAB]
    compile  new      test     
    [~]⇒ mytool 

Magique, non ? Il faut noter que l'auto complétion fonctionnera aussi
avec des options:

``` bash /etc/bash_completion.d/mytool
complete -W "new compile test --verbose" mytool
```

    [~]⇒ mytool c[TAB] -[TAB]
    mytool compile --verbose

Donc, comment ça marche ? Voici la traduction de l'aide de `complete`,
simplifiée au maximum:

**complete** [*options*] *name*     
Spécifie comment les arguments doivent être complétés, pour chaque *name*.

L'option `-W` permet de lui passer une liste de mots. Finalement c'était
facile ? Humm… En fait ce sera rarement aussi simple. Pour continuer notre
jeu de rôle, disons que l'option `--verbose` peut s'appliquer uniquement
à l'argument `new`, et pas aux deux autres. Du coup, notre commande
`complete` ne suffit plus. Il va falloir trouver autre chose et c'est ce
qu'on verra dans un prochain article.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}



