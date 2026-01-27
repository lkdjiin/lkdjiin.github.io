---
layout: post
title: "Horloge manuelle et sélecteur"
date: 2026-01-27 8:00
comments: true
tags: [ 8bits, retro ]
---

Pouvoir envoyer une seule pulsation manuellement devrait être bien utile
pour la mise au point de mon futur ordinateur 8 bits. C'est parti.

<!-- more -->

## Une pulsation unique

Je n'ai pas grand chose à dire à propos de ce montage. Il produit une pulsation
d'un dixième de seconde au minimum (en réalité aussi longtemp que vous appuyez
sur le bouton).

{% img center /images/horloge005.png %}

## Un sélecteur

Voici un autre montage qui nous permettra de sélectionner
[l'horloge automatique](/blog/2026/01/26/une-horloge-reglable/)
 ou l'horloge manuelle.
Je n'ai pas fait de schéma car je me suis aperçu qu'[il en existe déjà ici](https://eater.net/8bit/clock).

{% img center /images/horloge006.jpg %}

Je n'avais pas d'interrupteur SPDT adapté pour les _breadboard_ alors je fais
avec les moyens du bord. Si ça continue comme ça je vais devoir sortir le fer à
souder pour réaliser quelques adaptateurs.

## Une petite précision

On pourrait penser qu'il suffit d'utiliser des interrupteurs pour ces deux
fonctions. Et que les deux circuits intégrés 555 sont un peu exagérés.
Pourtant le problème du rebond mécanique (qui est bien expliqué et illustré
dans les vidéos de Ben Eater) est réel et nous oblige à trouver une solution.
On peut utiliser autre chose que du 555 pour résoudre ce problème, mais
j'imagine que l'auteur en avait une pleine caisse sous la main, alors pourquoi
pas.

## Conclusion

{% img center /images/horloge007.jpg %}

La prochaine étape devrait être de rassembler l'horloge automatique et
l'horloge manuelle en une sortie unique et de pouvoir sélectionner celle qu'on
veut.

{% include serie_ordi_8bits.md %}
