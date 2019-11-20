---
layout: post
title: "Quelques oscillateurs très simples"
date: 2019-11-20 17:05
comments: true
categories: [musique, synthèse, synthé, modulaire]
---

J'ai l'intention de fabriquer mon synthétiseur modulaire. Et comme il faut bien
commencer quelque part, un oscillateur semble un bon point de départ. Je
pourrais utiliser un Arduino, ou une plate-forme similaire, écrire quelques
lignes de code, et voilà. Mais ça aurait beaucoup moins de charme que de faire
un peu d'électronique en mode vintage. Je vais donc commencer par ce que
j'imagine être le plus simple : un oscillateur avec un seul composant principal
et quelques résistances et condensateurs.  Ça n'ira pas bien loin, ça fera
sûrement mal aux oreilles, mais au risque de me répéter «Il faut bien commencer
quelque part.»

<!-- more -->

## Qu'est ce qu'un oscillateur

Un oscillateur est un dispositif électronique qui produit un signal électrique
ayant la forme d'une onde.  Une onde électrique, c'est un motif, une forme, que
produit la sortie du dispositif en Volt, qui oscille entre un minimum et un
maximum, et qui se répète, encore et encore.  On rencontre couramment les types d'ondes
carrée, triangle, en dent de scie, et enfin, sinusoïdale.

<a title="Omegatron translated by Roland Brierre [CC BY 3.0 (https://creativecommons.org/licenses/by/3.0)], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:Formes_d%27onde.png"><img width="512" alt="Formes d&#039;onde" src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Formes_d%27onde.png/512px-Formes_d%27onde.png"></a>

Chaque forme d'onde particulière produit une sonorité particulière quand on la
passe dans un haut-parleur. Une répétition - on dit aussi un cycle - par
seconde donne par définition une fréquence de 1 Hertz. C'est la hauteur
(musicale) de la note produite. Dix cycles par seconde correspondent à 10 Hertz.
Deux cent trente quatre cycles par seconde correspondent à 234 Hertz, etc. Un
Hertz est une fréquence beaucoup trop basse pour être entendue par les humains.
Des oreilles jeunes, en bonne santé, pas trop fatiguées, peuvent entendre les
fréquences comprises entre 40 et 20 000 Hertz, en gros.

## Onde carrée

### CD40106

Le premier oscillateur que j'ai testé à pour composant de base un CD40106, et produit une onde carrée.

{% img center /images/osc-40106.png %}

Si vous l'essayez, raccordez aussi les pins 3, 5, 9, 11 et 13 au ground. Et si
possible ajoutez lui un volume, la sortie pouvant être assez élevée. *(Dans
tous les cas, vous devriez toujours ajouter un contrôle de volume et mettre
votre ampli à zéro pour commencer ; ça vous évitera des mauvaises surprises.)*

On obtient une belle onde carrée :

{% img center /images/square-wave.jpg %}

### 74HC14

Le 74HC14, c'est la même chose qu'un CD40106 mais en 5 Volt, voire même moins.
Il est donc idéal si votre circuit doit fonctionner en 5 Volt ou moins.  Le
schéma est exactement le même que le précédent, pin pour pin. Pensez seulement
à bien utiliser du 5 Volt, sinon vous le grillerez.

### 555

{% img center /images/osc-555.png %}

Le 555 est un grand classique. Un des composants électroniques les plus utilisés au monde.

{% img center /images/bread-555.jpg %}

## Dents de scie

{% img center /images/osc-transistor.png %}

Je voulais aussi voir ce que je pouvais faire avec un transistor. Le résultat est
intéressant mais l'amplitude est un peu faible.

{% img center /images/sawtooth-wave.jpg %}

J'ai pu le faire fonctionner à 9 Volt avec un 2N2222A en
métal. Tout les autres types de transistors que j'ai essayé n'ont pas réussi à osciller. Je pense
que la plupart fonctionnerait avec 12 Volt. Il faudra que j'essaye plus tard
car je n'avais pas de 12 Volt sous la main.

## Les contrôles

De manière générale, augmenter la résistance diminue la fréquence. C'est à dire
que ça produit une note plus basse.  De même, augmenter la valeur du condensateur diminue
aussi la fréquence. Il ne faut pas hésiter à tester les différentes valeurs
qu'on a sous la main.

## Ce qui manque

Laissez moi le répéter une fois encore : il faut commencer quelque part. Et là,
ça n'est clairement que le début. Tel quel, ces oscillateurs sont inutilisables
dans un synthé. Voyons rapidement ce qui manque :

- **Plusieurs formes d'ondes**. Il me manque encore triangle et sinus. Et l'idéal serait qu'un seul oscillateur puissent produire plusieurs formes d'ondes.
- **Un contrôle fin de la fréquence**. Généralement les oscillateurs possèdent 2 contrôles de fréquence. Un grossier (*coarse*) qui balaye toute l'étendue du registre, et un plus fin de l'ordre d'un ou deux tons, qui permet de s'accorder précisément.
- **1V/oct**. C'est LA fonctionnalité que j'attends avec le plus d'impatience. Je pense que ce sera aussi la plus complexe à mettre en place. En gros, c'est ce qui permettra à mes oscillateurs de jouer des notes précises, à partir d'un clavier ou d'un séquenceur, par exemple.
- **Pulse modulation**. Un carré est aussi un rectangle. Pensez donc à une onde carrée comme à une onde rectangle, avec par exemples des «bosses» plus longues et des «creux» plus courts. Ça permet d'obtenir des nouvelles sonorités.
- **La synchro**. Mais c'est un peu normal car pour cela il faut un deuxième oscillateur. En gros c'est quand on utilise deux oscillateurs en même temps. L'un s'occupant de la fréquence et l'autre de la forme d'onde.
