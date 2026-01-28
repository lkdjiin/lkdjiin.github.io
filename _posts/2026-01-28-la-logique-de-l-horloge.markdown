---
layout: post
title: "La logique de l'horloge"
date: 2026-01-28 8:00
comments: true
tags: [ retro, 8bits ]
---

Dernière étape dans la construction de l'horloge : la logique qui permettra de
passer d'une utilisation automatique à une utilisation manuelle.

<!-- more -->


Le montage utilise un 74LS04 (portes NOT), un 74LS08 (portes AND), et un 74LS32
(portes OR). Le schéma se trouve ici : https://eater.net/8bit/clock

{% img center /images/horloge008.jpg %}

J'ai retrouvé dans mes cartons un potentiomètre et un interrupteur qui vont bien.
Tout tient sur une seule _breadboard_.
On peut voir en bleu l'horloge automatique, en vert l'horloge manuelle, et en
rose le switch "sans rebond". Le reste, c'est la partie logique.


## Notes

L'horloge fonctionne très bien, mais si c'était à refaire j'utiliserai plutôt
un arduino. Ça aurait été plus rapide à réaliser et ça tiendrait moins de place.
D'un autre côté, c'est un bon petit projet pour mettre les mains dans le camboui
si on a peu d'expérience.

Maintenant j'ai vraiment hâte de travailler sur le processeur 6502.

{% include serie_ordi_8bits.md %}
