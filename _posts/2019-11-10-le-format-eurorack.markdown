---
layout: post
title: "Le format Eurorack"
date: 2019-11-10 10:52
legacy: true
tags: [musique, synthèse, synthé, modulaire]
---

Eurorack est actuellement le format le plus populaire pour les synthétiseurs
modulaires.  C'est un standard de facto parmi la jungle des formats existants.
Du moins, c'est le standard «pas trop cher» car le format Moog Unit, plus
luxueux, est aussi assez populaire. Vous remarquerez que j'utilise des
guillemets autour de «pas trop cher» parce qu'un synthé modulaire, c'est de
toute manière onéreux.

<a title="Nina Richards (who can be contacted via ZoeB). [CC BY 3.0 (https://creativecommons.org/licenses/by/3.0)], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:Doepfer_A-100.jpg"><img width="256" alt="Doepfer A-100" src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Doepfer_A-100.jpg/256px-Doepfer_A-100.jpg"></a>

<!-- more -->

## Synthétiseur modulaire

Un synthétiseur modulaire est un synthétiseur dont vous agencez vous même les
différents modules. Vous choisissez des oscillateurs, des filtres, des
générateurs d'enveloppes, des effets, des amplis, des mixeurs, des séquenceurs,
des portes logiques, des horloges, etc, et vous les relier dans l'ordre que
vous voulez avec des câbles pour produire des sonorités, voir des musiques
complètes.  Les seules limites sont votre imagination et votre porte-monnaie
(parce que à première vue, c'est quand même honteusement cher).

J'ai envie d'un synthé modulaire depuis que j'ai vu un documentaire sur les Who
dans lequel Pete Townshend recréait les sonorités de «Won't get fooled again»
dans son home studio. En écrivant cet article j'ai recherché ce documentaire,
mais je n'ai pas réussi à le retrouver. Et ça n'était peut-être même pas
vraiment un synthé modulaire. Mais c'est toujours resté dans un coin de ma
tête.

## Les spécifications du format Eurorack

Eurorack est un ensemble de spécifications plutôt laxistes, initiées par
l'entreprise Doepfer en 1996, pour définir la taille des modules, les
mécanismes de montage et les détails de l'alimentation électrique, des différents types de
connecteurs et du transport de l'information (audio, gate, trigger).

Ce que tout le monde peut voir facilement, c'est la taille des modules. On
donne généralement la hauteur des modules d'un synthé modulaire, comme de tout
matériel qui se monte en rack, en unité **U** (pour Rack Unit). On parle donc
d'une hauteur de 1U, de 2U, de 3U, 4U, 5U, etc. Le Rack Unit mesure 44,45 mm.
Donc 3U devrait faire 133,35 mm. Mais pas pour Eurorack. Pour EuroRack, 3U
mesure 128,5 mm. Pourquoi ? J'avoue que je n'ai pas tout compris.

Pour la largeur d'un module on parle de HP (pour Horizontal Pitch). Un HP
corresponds à 5,08 mm et les modules sont censés avoir une largeur qui est un
multiple de 1HP.

Pour l'anecdote, Doepfer défini aussi des spécifications pour la longueur et la
largeur des vis de montage.

Du côté de l'alimentation, un module utilise du +12 volt, du -12 volt et
nécessite un *ground* à 0 volt. Certains modules peuvent aussi avoir besoin de
+5 volt, une tension classique pour les Arduino & Cie. Les modules sont
connectés à l'alimentation par une prise ruban à 16 broches (mais parfois seulement
10 broches, standard, vous avez dit standard).

<a title="Heron 21:16, 22 Nov 2004 (UTC) [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0/)], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:Flachbandkabel.jpg"><img width="128" alt="Flachbandkabel" src="https://upload.wikimedia.org/wikipedia/commons/6/65/Flachbandkabel.jpg"></a>

Les tensions de travail en interne (audio, CV, trigger, clock) sont définies de
manière assez laxistes. Un signal audio est censé se cantonner entre -5 volt et
+5 volt.  Un CV (control voltage) est normalement de 5 volt entre deux pics et
peut-être uni polaire ou bipolaire. En clair il peut se balader quelque part
entre -2,5 volt et +2,5 volt, jusqu'à entre 0 volt et +5 volt.
Trigger, gate et clock sont censés être des signaux numériques, 0 volt ou 5 volt.

Enfin, les connexions entre modules sont réalisées avec des petits jacks (3,5 mm).

## D'autres formats

Il existe d'autres formats (ou form factors) de synthé modulaires. Le format
Moog Unit est surement le plus populaire après Eurorack. Et le format FrackRack
est celui qui se rapproche le plus de Eurorack. Voici ces trois formats en résumé :

**Eurorack**    
Hauteur : 3U (moins de 13 cm)    
Tensions : +/-12v +5v    
Jack : petit    

**Moog Unit (MU)**    
Hauteur : 5U (environ 22 cm)    
Tensions : +/-15v +5v    
Jack : gros    

**FrackRack**    
Hauteur : 3U    
Tensions : +/-15v    
Jack : petit

Parmi tout les formats que j'ai exploré, la hauteur peut aller tout de même
jusqu'à 40cm (Technosaurus Selector).  Quant à l'alimentation, on trouve de
tout entre -18 volt et +24 volt.

## Sources

https://en.wikipedia.org/wiki/Eurorack

http://www.doepfer.de/a100_man/a100m_e.htm

http://www.doepfer.de/a100_man/a100t_e.htm

https://sdiy.info/wiki/Eurorack

https://sdiy.info/wiki/Eurorack_DIY_parts

https://www.synthesizers.com/formfactors.html

https://en.wikipedia.org/wiki/Rack_unit
