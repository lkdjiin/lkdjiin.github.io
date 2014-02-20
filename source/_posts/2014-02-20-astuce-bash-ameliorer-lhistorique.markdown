---
layout: post
title: "Astuce Bash - Améliorer l'historique"
date: 2014-02-20 21:02
comments: true
categories: [bash, débutant, astuce]
---

{% level 1 %}

Dans Bash, chaque appui sur la touche «flêche vers le haut» fait défiler
l'historique des commandes. Si la commande recherchée se situe à quelques
dizaines d'appuis, ça n'est pas très pratique. Voici une astuce pour
aller plus vite.

<!-- more -->

Ajoutez les lignes suivantes dans votre fichier `~/.inputrc`. Si ce dernier
n'existe pas, créez le.

``` bash ~/.input
"\e[A": history-search-backward
"\e[B": history-search-forward
set show-all-if-ambiguous on
set completion-ignore-case on
```

Maintenant il suffit de saisir les premières lettres de la commande
recherchée et la flêche vers le haut ne fera défilée que les commandes
de votre historique qui commencent par ces caractères.

Quand j'aurais plus de temps, j'aimerais revenir sur ces lignes pour
fournir une explication, en attendant je vous souhaite une bonne
utilisation de votre historique boosté ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


