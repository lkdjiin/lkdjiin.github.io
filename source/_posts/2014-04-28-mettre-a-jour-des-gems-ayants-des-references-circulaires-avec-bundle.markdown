---
layout: post
title: "Mettre à jour des gems ayants des références circulaires avec Bundle"
date: 2014-04-28 21:25
comments: true
categories: [ruby, bundle, débutant, gem, gemfile]
---

{% level 1 %}

Ok, c'est sûrement le titre le plus incompréhensible de l'histoire de ce
blog. Mais je n'arrive pas à trouver mieux…

Prenons le Gemfile fictif suivant:

    gem a
    gem b
    gem c

Je veux mettre à jour la gem a, de la version 1.0.0 vers la nouvelle version
1.0.1.

<!-- more -->

Pour ça je fais évidemment:

    bundle update a

Mais voilà que `bundle` me répond quelque chose comme ça:

    impossible de mettre à jour la gem a
    la gem a 1.0.1 dépend de la gem b 1.0.1

D'accord, pas de souci, je fais donc:

    bundle update b

Et devinez ce que ce cher `bundle` me répond ?

    impossible de mettre à jour la gem b
    la gem b 1.0.1 dépend de la gem c 1.0.1

Bon, j'espère que c'est bientôt fini. Parce que évidemment mon Gemfile
réel ne comporte pas que 3 gems, lui. Donc je me soumet:

    bundle update c

Et la réponse ne tarde pas:

    impossible de mettre à jour la gem c
    la gem c 1.0.1 dépend de la gem a 1.0.1

Super :( J'ai l'impression qu'on me demande de remplir un formulaire
administratif ! La gem a dépend de b, qui elle, dépend de c, qui à son
tour dépend de a…

Malgré tout, la solution est très simple (merci collègue
[@hellvinz](https://twitter.com/hellvinz)) il suffit de mettre à jour les
3 gems en même temps:

    bundle update a b c

Et le tour est joué. Peut-être que vous le saviez déjà ? Mais moi j'avais
raté cette partie de Bundle.

Aujourd'hui j'ai encore appris quelque chose :)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

