---
layout: post
title: "Le système binaire"
date: 2015-06-04 13:55
legacy: true
tags: [binaire, boole, débutant]
---



J'ai appris l'algèbre de Boole au lycée, j'ai programmé en assembleur très tôt,
j'ai donc de bonnes raisons de connaître le binaire ; ce truc fait en quelque
sorte partie de moi.  Par expérience, je sais que certains développeurs manque
de connaissances dans le domaine, mais pas pour autant de curiosité.  Alors si
vous n'êtes pas sûr de savoir ce qu'est vraiment le système binaire, continuez
la lecture…

{% img center /images/one-plus-one.png %}

<!-- more -->

**Le système binaire est une manière de compter**, tout comme le système
décimal que vous connaissez bien. Sauf qu'au lieu de compter en se basant sur
le nombre 10 (on dit aussi «compter en base dix»), on compte avec une base
deux. Le système décimal et le système binaire ne sont pas les seuls systèmes
de «comptage» existants, loin de là. Vous connaissez (et utilisez) d'autres
systèmes, comme le système en base 60 pour compter les secondes et les minutes
et le système en base 24 pour compter les heures.  Tout ça pour dire et redire
qu'**il n'y a absolument rien de bizarre à compter autrement qu'en base 10**.

Pourquoi, alors, le système décimal nous semble être *LE* système de référence ?
Et pourquoi 10, d'ailleurs ? Certainement parce qu'**on a dix doigts**, il est
donc naturel de prendre 10 comme base. Mais si nous rencontrions des
extra-terrestres à 8 doigts, il y a fort à parier que leur système *naturel*
serait en base 8.

Le système décimal possède dix symboles, qui représentent chacun une valeur que
j'appellerai *unitaire* : 0, 1, 2, 3, 4, 5, 6, 7, 8 et 9. Ces symboles peuvent
se combiner à l'infini pour représenter d'autres valeurs. **C'est pareil pour
les autres systèmes**, ils représentent un certain nombre de valeurs en utilisant
des symboles :

    Système     | # de symboles | Symboles
    -------------------------------------------------------------
    hexadécimal | 16            | 0 1 2 3 4 5 6 7 8 9 A B C D E F
    décimal     | 10            | 0 1 2 3 4 5 6 7 8 9
    octal       |  8            | 0 1 2 3 4 5 6 7
    binaire     |  2            | 0 1

Le système binaire doit représenter seulement deux valeurs.  On utilise
généralement des 1 et des 0, mais on pourrait exprimer/symboliser ces valeurs
par n'importe quoi d'autre : vrai et faux, 5 volts et 0 volts, oui et non,
rouge et vert, allumé et éteint, haut et bas, etc.

Pourquoi a-t-on besoin d'un système avec seulement deux valeurs ?
**i)** parce que ça représente bien **la logique** : ceci *OU* cela, ceci *ET* cela.
**ii)** parce que c'est le système de comptage **le plus simple** (du moins pour une machine) et que simplicité est généralement synonyme d'efficacité.

Pour illustrer ce dernier point, et terminer cet article d'introduction au
système binaire — *j'espère qu'il y en aura plein d'autres* —  voici le
résultat de l'opération logique 1 OU 1, et celui de l'addition de 1 + 1 :

    1 OU 1 = 1
    1  + 1 = 10

Pour comprendre comment tout cela fonctionne, rendez-vous dans les prochains
articles.


