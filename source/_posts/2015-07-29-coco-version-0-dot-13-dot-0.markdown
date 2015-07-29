---
layout: post
title: "Coco version 0.13.0"
date: 2015-07-29 10:50
comments: true
categories: [annonce, ruby, gem, coco, couverture de code, test]
---

Je me rend compte que j'ai sorti la version 0.13.0 de
[coco](https://github.com/lkdjiin/coco)
il y a près d'un mois et que je n'ai pas encore écrit une seule ligne sur le
sujet !

Coco est un outil de **co**uverture de **co**de pour Ruby — **co**de
**co**verage en anglais —. En gros, coco vous dit quels sont les fichiers d'un
projet qui ne sont pas suffisament testés :

{% img center /images/coco-shot-1.png %}

<!-- more -->

Puis, pour les fichiers qui ne sont pas couverts à 100% par les tests, vous
pouvez visualiser les parties du code qui ne sont pas couvertes (ici en rouge) :

{% img center /images/coco-shot-2.png %}

Qu'y a-t-il de nouveau dans cette version 0.13.0 ? J'ai essentiellement
travaillé sur l'aspect du rapport HTML, afin qu'il soit un peu plus agréable
à regarder (je ne suis toujours ni graphiste ni designer, mais je crois que
cette fois ça n'est pas trop mal). On peut retenir aussi que les versions de
Ruby inférieures à 2 ne sont plus supportées.

Il ne reste plus grand chose à faire avant la [version 1.0](https://github.com/lkdjiin/coco/issues). Ça sera peut-être pour la fin de cette année, 5 ans après la première release, qui sait ?

{% connexe %}
