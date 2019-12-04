---
layout: post
title: "Fabriquer une vactrol pour piloter un oscillateur"
date: 2019-12-04 16:07
comments: true
categories: [musique, synthèse, synthé, modulaire, oscillateur]
---

Vactrol, comme Frigidère ou Mobylette, c'est une marque passée dans le langage
courant pour désigner l'objet. En français on peut aussi utiliser photocoupleur,
optocoupleur, ou opto-isolateur.  Je continuerais quand même à employer le terme «vactrol»
pour plus de simplicité.

## C'est quoi ?

Une vactrol est la combinaison d'une source lumineuse, une LED dans notre cas mais n'importe quoi peut fonctionner en théorie,
et d'un récepteur, ici ce sera une photorésistance.
Le tout doit être isolé de la lumière extérieure du mieux possible.

Une photorésistance est un composant dont la résistance change en fonction de la quantité de lumière reçue.
Plus la LED sera lumineuse, plus la résistance de la photorésistance va chuter.
Inversement, plus la LED sera sombre, inactive, plus la résistance du dispositif
sera importante.

<!-- more -->

## À quoi ça va servir ?

Ça va nous servir à contrôler, moduler, modifier, la fréquence d'un oscillateur de manière
automatique. Par l'intermédiaire d'un autre oscillateur par exemple, ou de
n'importe quel autre dispositif qui sera source de voltage.

Aujourd'hui il n'est pas toujours simple de trouver sur le marché des optocoupleurs
avec photorésistance. On en trouve plutôt à base de phototransistor ou de photodiode.
Mais ceux avec photorésistance ont été pas mal utilisé dans les amplis et les
pédales d'effet pour guitares. Notamment pour réalisé des compresseurs et des trémolos.

## Comment en fabriquer ?

Il est plutôt facile de fabriquer soi-même une vactrol. La qualité ne sera pas
forcement aussi bonne qu'une vactrol du commerce, mais pour des applications
audio c'est souvent amplement suffisant.

Voici les ingrédients nécessaires :

- une LED
- une photorésistance
- du tube thermorétractable
- de la colle
- une petite pince
- un briquet

{% img center /images/vactrol-1.jpg %}

### 1 Coller la LED sur la photorésistance

Il n'est pas strictement nécessaire de coller LED et photorésistance ensemble,
mais ça simplifie fortement la suite.

{% img center /images/vactrol-2.jpg %}


### 2 Gainage

Une fois la colle sèche, on coupe un morceau de gaine. On chauffe. On aplati
bien les bords encore chauds avec la pince. Et c'est fini.  Sur la photo on
voit que j'ai coupé un peu plus que nécessaire la patte négative de la LED,
pour être sûr de bien la repérer lors du futur montage.

{% img center /images/vactrol-3.jpg %}

## Comment l'utiliser ?

{% img center /images/vactrol-4.png %}

Placez la vactrol à la place du potentiomètre de l'[oscillateur](http://lkdjiin.github.io/blog/2019/12/02/fonctionnement-dun-oscillateur-a-base-de-cd40106/).
N'oubliez pas de connecter une petite résistance après ou avant la LED, pour ne
pas la griller. Puis raccordez votre source de voltage à l'entrée FM et le tour
est joué.

Vous pouvez aussi ajouter un potentiomètre en série avec la vactrol pour sélectionner la fréquence de base.

Je suis très intéressé par vos trucs, astuces, ou anecdotes sur les vactrols. Alors écrivez ça dans un commentaire. Merci et à bientôt.
