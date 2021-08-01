---
layout: post
title:  "La porte logique NOT"
date:   2021-08-01 13:30:18 +0200
comments: true
tags:
---

J'ai écrit précédemment que ma machine à calculer serait construite uniquement
avec des portes logiques NOR, comme l'ordinateur de guidage des missions Apollo.
On va pourtant parler d'autre chose : la porte logique NOT. Pourquoi ?
Parce que c'est la plus simple et que le NOR, que l'on verra dans un prochain
article, n'est qu'une variation du NOT.

Une porte logique (_logic gate in english_) est un dispositif qui prend une ou
plusieurs valeurs binaires en entrée, applique une transformation sur les
entrées, et produit finalement une sortie binaire.

## NOT

| in | out |
|----------|
|  0 |   1 |
|  1 |   0 |

La fonction d'une porte logique NOT est évidente : si elle reçoit un 0 logique
en entrée, elle répond avec un 1 logique en sortie. Et vice-versa, si elle
reçoit un 1 logique en entrée, elle répondra avec un 0 logique en sortie. On
peut encore le dire autrement : la sortie d'une porte NOT est l'inverse de son
entrée.

Quand je parle de 0 logique et de 1 logique, ça veut dire quoi ? Prenons un
raccourci qui devrait tenir assez longtemps : comme j'utiliserai un adaptateur
9 volts pour alimenter ma machine à calculer je dis que le 0 logique vaut 0
volts, et que le 1 logique vaut 9 volts.  Voilà les deux valeurs avec
lesquelles on raisonnera théoriquement. Dans la pratique on mesurera peut-être
des valeurs légèrement différentes, mais peu importe.

Voici le symbole d'une porte NOT, que vous trouverez dans nombre de schémas
électroniques :

{% img center /images/not-symbole.png %}

Voici maintenant comment construire ce NOT avec un transistor et deux
résistances :

{% img center /images/not-1.png %}

Attention, vous ne pouvez pas utiliser n'importe quel transistor au hasard. Il
faut ce qu'on appelle un BJT NPN. On a de la chance, ce sont les plus communs,
comme par exemple les 2N2222, 2N3904 ou encore 2N5088.
J'ai choisi d'utiliser le 2N3904 car j'en ai quelques centaines en stock.

Quand on applique 9 volts en entrée, on mesure 0 volts en sortie.
Et bien sûr à l'inverse, quand on applique 0 volts en entrée, on mesure 9 volts
en sortie.

Mais alors, comment ça marche ? Je n'aurai pas la prétention d'expliquer dans
le détail le fonctionnement d'un transistor. Je vais quand même tenter de
«modéliser» à ma manière son utilisation dans le domaine numérique. Sachez donc
que les explications et les petits dessins qui vont suivre sont des modèles, et
pourront être assez loin de la réalité.

Tous d'abord un transitor possède 3 entrées/sorties, notées e, b, et c, pour
*emitter*, *base*, et *collector*. Voici le symbole utilisé dans un schéma
électronique :

{% img center /images/not-2.png %}

Et voici le composant réel :

{% img center /images/ebc.jpg %}

On peut imaginer la base comme un interrupteur actionné électriquement. Cet
interrupteur va connecter ou déconnecter l'émeteur au collecteur. Lorsqu'on
applique 9 volts sur la base, le flux d'électrons va "pousser" sur
l'interrupteur et ainsi relier e et c.  Au contraire, lorsqu'on branchera la
base sur le ground, autrement dit 0 volts, c'est comme si "l'absence" de flux
créait un vide et allait "tirer" l'interrupteur en déconnectant au passage e et
c :

{% img center /images/not-3.png %}

Pour comprendre pourquoi on utilise la résistance Rin sur la base, on fait
appel au «modèle» le plus connu et le plus utilisé : la loi d'Ohm, qui stipule
que les volts = la résistance X les ampères. Si on admet que la résistance de
la base est théoriquement nulle on a alors un gros problème si on ne met pas la
résistance Rin : volts = 0 x ampères. On met donc une résistance Rin pour, en
quelque sorte, permettre au transistor de "voir" l'électricité :

{% img center /images/not-4.png %}

On en sait maintenant suffisamment pour expliquer le circuit.

Quand Rin est connecté au ground, donc 0 Volts, e et c sont déconnectés et le
flux électrique n'a d'autre choix que de s'écouler de vcc (9 volts) vers out,
via la résistance R1. C'est l'unique chemin possible :

{% img center /images/not-7.png %}

Quand Rin est connecté à 9 volts, e et c sont reliés. Le flux va alors s'écouler
naturellement du ground (0 volts) vers out, en passant par l'émetteur puis le
collecteur :

{% img center /images/not-8.png %}

Vous pourriez  m'objecter que VCC (autrement dit 9 volts) est toujours relié à out
via R1. Alors ? Comment ça peut fonctionner sans exploser ? Il se trouve que
l'électricité, qui est une forme d'énergie, est une parfaite illustration du
principe d'Occam. Elle optera toujours pour le chemin le plus court, celui qui
demande le moins d'effort. En d'autres termes, l'électricité préferera le chemin
qui offre la moindre résistance.

Pour finir, voici la porte logique NOT en action avec une LED.
 D'abord 9 volts en entrée (notez le petit bout de câble vert qui amène 9 volts), et la LED éteinte :

{% img center /images/not-off.jpg %}

Et puis 0 volts en entrée (notez cette fois le câble vert qui plonge dans le ground et positionne donc
l'entrée à 0 volts), et donc la LED allumée :

{% img center /images/not-on.jpg %}

À la prochaine pour parler d'une autre porte logique : NOR.

{% include serie_001.md %}
