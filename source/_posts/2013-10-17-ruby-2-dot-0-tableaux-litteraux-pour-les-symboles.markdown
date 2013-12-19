---
layout: post
title: "Ruby 2.0: Tableaux littéraux pour les symboles"
date: 2013-10-17 10:48
comments: true
categories: [ruby, débutant, ruby 2.0]
---

{% level 1 %}

La version 2.0 de Ruby gagne une nouvelle syntaxe pour la définition
de tableaux de symboles : `%i`.

On a maintenant le choix pour définir un tableau de symboles entre les deux
syntaxes suivantes:

``` ruby
[:voici, :plusieurs, :symboles]

%i( voici plusieurs symboles )
```

<!-- more -->

On y gagne en clarté mais aussi, le langage y gagne en cohérence. On est
habitué à utiliser `%w` pour les tableaux de chaînes de caractères, il n'y
avait pas de raison pour qu'on ne puisse pas le faire avec des symboles.
J'aime beaucoup cette nouvelle possibilité, même si je ne vois pas
le rapport entre la lettre `i` et les symboles…

Il existe aussi une version qui permet l'interpolation, c'est `%I` (avec
un i majuscule). Vous pouvez voir la différence entre `%i` et `%I` dans la
session suivante:

``` irb
>> %i( #{"bé" + "po"} azerty )
[
    [0] :"\#{\"bé\"",
    [1] :+,
    [2] :"\"po\"}",
    [3] :azerty
]
>> %I( #{"bé" + "po"} azerty )
[
    [0] :bépo,
    [1] :azerty
]
```



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

