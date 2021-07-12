---
layout: post
title: "Fonctionnement d'un oscillateur à base de CD40106"
date: 2019-12-02 20:41
legacy: true
tags: [musique, synthèse, synthé, modulaire]
---

Dernièrement j'ai écrit un article qui montre quelques oscillateurs simples,
mais sans fournir d'explications sur le fonctionnement.  Aujourd'hui je vais
tenter d'expliquer ce qu'il se passe, comme j'aurais aimé qu'on m'explique
quand j'ai débuté l'électronique.

Le CD40106 est un inverseur logique, il applique la fonction NOT. Si le signal
en entrée est un 1 logique, le signal en sortie sera un 0 logique. Inversement,
si le signal en entrée est un 0 logique, le signal en sortie sera un 1 logique.

C'est donc du numérique, et ça semble simple.

Mais qu'est ce qu'on entend par 0 et 1 logique ?
Quand le circuit intégré CD40106 est alimenté par une pile 9
Volt, le 0 logique en sortie correspond à un signal de 0 Volt et le 1 logique
correspond, toujours en sortie, à un signal de 9 Volt (à peu près).  Par contre en entrée,
c'est un peu plus compliqué, parce que l'électronique c'est jamais seulement
numérique. Mais on y reviendra plus tard.

Voici l'oscillateur dont je parle dans la suite de l'article :

{% img center /images/oscillo-cd40106.png %}

<!-- more -->

## Le circuit

Lorsqu'on branche la pile, le signal au point A est un 0 logique, il n'y a pas
de tension en entrée. Rien. Zéro. Nada. Donc le circuit intégré produit un 1 logique en sortie, au point B.
Ce niveau de sortie durera jusqu'à ce que l'entrée s'inverse.

{% img center /images/onde-carree-1.png %}

Une bonne partie des électrons vont se bousculer vers la sortie OUT (un haut-parleur par exemple). Mais comme l'électricité aime
emprunter tout les chemins possibles, quelques électrons vont retourner au point A, via la résistance R1.
Arrivé au point A, ces électrons sont attirés par le ground comme des fourmis par le miel.
Mais ils n'atteindront jamais le ground, car ils vont se retrouver piégé à l'intérieur du condensateur C1.
Et pendant ce temps, la sortie du circuit intégré est toujours à 9 Volt.

Arrive fatalement le moment où le condensateur C1 est plein et ne peut plus
accueillir de nouveaux électrons. Mais ils arrivent toujours au point A par
l'intermédiaire de la résistance. Ils vont alors emprunter l'entrée du circuit
intégré. Et comme le CD40106 a maintenant un 1 logique en entrée il va produire
un 0 logique en sortie.

{% img center /images/onde-carree-2.png %}

Les électrons n'arrivent plus vers le point A via R1, puisque la sortie du
circuit intégré est dorénavant à zéro. Par contre, le condensateur commence
a libérer ses électrons, ce qui maintient l'entrée du CD40106 au niveau du
1 logique.

Et puis, quand le condensateur à épuisé toute sa réserve d'électrons, le point A
passe de nouveau au 0 logique et le cycle peut recommencer. Ce qui produit une
onde carrée.

{% img center /images/onde-carree-3.png %}

Tout ça est très simplifié, et c'est un peu le monde des bisousnours numériques.
Malgré tout, c'est un premier niveau de compréhension.

## Entrée analogique et hystérésis

Comme je l'ai laissé entendre dans l'introduction, la grande simplification de
l'explication précédente est de prétendre que le signal en entrée (point A) est
numérique. C'est à dire 0 Volt ou 9 Volt. À cause du condensateur (ou grâce à
lui, c'est selon le point de vue) le signal au point A est une onde de type plus ou moins
triangulaire.  Pendant une même période de temps, le condensateur en charge
attire plus d'électrons quand il est vide que quand il est déjà un peu rempli.
De même, il rejette plus d'électrons au début de sa décharge.

Pour cette raison, l'inverseur logique fonctionne avec un seuil. Quand le signal est
en dessous du seuil, l'entrée est à 0, et inversement. Mais pour pouvoir
réaliser un oscillateur, un seul et unique seuil ne va pas être suffisant.
Sitôt le seuil franchi, l'état va s'inverser. Ce qui fera aussitôt franchir le
seuil dans le sens inverse, et de nouveau inverser l'état. Etc. Le signal en
entrée resterait coincé sur le seuil, ni vraiment 0, ni vraiment 1.

Le CD40106 fonctionne grâce au principe
d'[hystérésis](https://fr.wikipedia.org/wiki/Hyst%C3%A9r%C3%A9sis), ou hystérèse.
En pratique il y a deux seuils, et seulement l'un de ces seuils est actif à un
instant donné. Le schéma suivant est extrait du *datasheet* et j'ai ajouté les
point en rouge, qui représentent des instants dans le temps.

{% img center /images/hysterisis.png %}

Au premier point rouge, la tension franchit le seuil *VT+*, qui est actif. Le circuit
considère donc l'entrée comme un 1 et produit une sortie à 0. À partir de ce
moment, le seuil *VT+* devient inactif, et c'est le seuil *VT-* qui prend le relai et devient actif.

Au second point rouge, bien qu'on ai franchi plusieurs fois le seuil *VT+* dans
un sens et dans l'autre rien ne change.

Au troisième et dernier point, le signal franchit *VT-*, le seuil actif, et
donc la sortie s'inverse.

C'est ça l'hystérésis, un changement d'état suivant un évènement externe **et** l'état actuel.
Et c'est bien utile pour faire un oscillateur avec un inverseur.

C'est fini pour aujourd'hui. Si vous avez repéré des erreurs dans cet article, n'hésitez pas à le signaler dans un commentaire. Merci et à bientôt.
