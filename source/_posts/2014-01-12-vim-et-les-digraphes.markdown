---
layout: post
title: "Vim et les digraphes"
date: 2014-01-12 11:27
comments: true
categories: [vim, débutant, digraphe]
---

{% level 1 %}

Comment saisir facilement et rapidement des caractères tels que ¡, ¿ ou encore
ß dans Vim ?

<!-- more -->

Pour voir à quoi ressemble ces fameux digraphes dans Vim, tapez la commande
`:digraphs`. Vous allez obtenir la liste des digraphes qui sont définis.
La définition d'un digraphe ressemble à ceci:

    ?I ¿  191

Ici, seules les deux premières colonnes nous intéressent. La première colonne
est le code de deux caractères qu'il faut saisir pour obtenir le caractère 
de la seconde colonne.

Pour saisir un digraphe, il faut être en mode insertion et entrer
Control + k, puis les deux caractères du code. Donc `Control`, puis `k`,
puis `?`, puis `I` donnera le caractère `¿`.

Voici quelques exemples:

    !I ¡
    ?I ¿
    ss ß
    %0 ‰
    13 ⅓
    78 ⅞
    l* λ
    p* π
    -> →
    => ⇒

Si vous utilisez régulièrement certains digraphes, il existe une manière
plus rapide de les saisir. Activez tout d'abord l'option `digraph` dans
votre `.vimrc`:

``` vim
set digraph
```

Maintenant vous pouvez saisir un digraphe en entrant le premier caractère
du code, puis la touche Backspace, puis le second caractère du code.
Donc `p`, puis `Backspace`, puis `*` vous donneront le caractère Pi (`π`).
Attention quand même avec cette option, si vous faites régulièrement des
fautes de frappes, vous risquez de voir apparaître assez souvent des caractères
étranges et inattendus ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

