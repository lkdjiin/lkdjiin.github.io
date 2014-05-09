---
layout: post
title: "Le langage Julia"
date: 2014-05-09 21:27
comments: true
categories: [intermédiaire, julia, programmation fonctionnelle]
---

{% level 2 %}

Aujourd'hui j'ai commencé à jouer un peu (2 heures à peine) avec le langage
[Julia](http://julialang.org/).
Ça faisait longtemps que j'en avais envie et j'ai été enthousiasmé.

<!-- more -->

Je cherche un langage fonctionnel qui, entre autres,:

- ne soit pas *purement* fonctionnel.
- soit rapide.
- ai une syntaxe assez simple.

J'ai peut-être trouvé ça avec Julia. Cet après-midi j'ai installé la
version binaire sur OS X sans problème. En ce moment je suis en train de
la compiler sur Debian (c'est très long…).

J'en suis encore à faire le tour de la syntaxe en suivant
[cette introduction](http://learnxinyminutes.com/docs/julia/). J'en parlerais
plus quand j'aurais un peu avancé ;)

Deux/trois trucs que j'ai retenu:

L'operateur de division est logiquement:

``` julia
5 / 2 # => 2.5
```

Mais plus surprenant (pour moi en tous cas):

``` julia
2 \ 5 # => 2.5
```

J'ai hâte de savoir si il y a une utilité à ça ;)

J'ai eu aussi plaisir à retrouver une arithmétique binaire, par exemple
la multiplication par 2:

``` julia
8 << 1 # => 16
```

Dernier truc, et je m'arrête là, j'aime quand les indices commencent à
1, et non pas à 0:

``` julia
"Bonjour"[1] # => 'B'
```


<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

