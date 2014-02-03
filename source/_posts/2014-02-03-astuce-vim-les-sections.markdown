---
layout: post
title: "Astuce Vim - Les sections"
date: 2014-02-03 20:39
comments: true
categories: [vim, débutant, mouvement]
---

{% level 1 %}

Je viens juste de découvrir deux nouveaux mouvements avec Vim que
j'aimerais partager avec vous:
section suivante et section précédente.

<!-- more -->

Pour aller à la section suivante :

    ]]

Pour aller à la section précédente :

    [[

Le tout étant de savoir ce qu'est une section !? J'étudierais l'aide
de Vim plus tard… Pour l'instant, voici ce que ça donne avec les
langages suivants:

**Bash, C** : Va au caractère `{` d'une fonction
 (uniquement quand il débute une ligne).

**Python** : Va à chaque `class` et `def`.

**Ruby** : Va à chaque `module` et `class`.

**Vim** : Va à chaque `function`.

Notez que ça semble ne rien faire avec les fichiers Javascript,
Racket, Scheme, Java, Haskell, et j'en passe. Je n'ai pas plus
d'informations pour l'instant, mais je compte bien m'y pencher de
plus près. En attendant, si vous avez des connaissances sur ces
mouvements, n'hésitez pas à nous en faire profiter dans un
commentaire.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

