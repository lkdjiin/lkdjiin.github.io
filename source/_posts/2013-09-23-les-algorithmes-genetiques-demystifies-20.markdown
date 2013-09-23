---
layout: post
title: "Les algorithmes génétiques démystifiés 20"
date: 2013-09-23 18:41
comments: true
categories: [algorithme génétique, ruby, intermédiaire, bilan]
---

{% level 2 %}

C'est le vingtième article de cette série sur les algorithmes génétiques et
j'aimerai en profiter pour dresser un petit bilan provisoire.

<!-- more -->

On a vu le fonctionnement d'un algorithme génétique à l'aide de deux exemples
simples. Dans le premier exemple il s'agissait de trouver une expression comme
«123+54x3» et dans le second il fallait trouver la chaîne «Mon royaume pour un
cheval».

On a appris à représenter une population d'individus. Chaque individu étant une
solution potentielle du problême posé. Cette solution est codée dans le
chromosome d'un individu. On a vu l'utilisation «historique» d'une chaîne de
bits pour réprésenter les chromosomes, mais aussi qu'on pouvait utiliser une
chaîne de caractères quelconques. En fait, il ne faut pas hésiter à représenter
les chromosomes comme bon vous semble.

On a vu ensuite la phase d'évaluation de la population. Il s'agit d'abord
d'évaluer un chromosome seul en lui affectant un score, puis de l'évaluer par
rapport aux autres chromosomes, en lui affectant un *fitness* (aptitude).  Le
fitness permettant d'être plus fin lors de l'étape de sélection.

Pour l'étape de la sélection, nous avons vu deux manières de faire :
l'élitisme et la roue de la fortune. L'élitisme consiste à ne conserver
qu'un pourcentage des meilleurs spécimens d'une génération. La roue de la
fortune consiste à donner à chaque individu une chance plus ou moins
grande de se reproduire en rapport avec son *fitness*.

Nous avons fait se reproduire les individus/solutions selectionnés par
croisement de leurs chromosomes. À partir de deux parents, nous avons
obtenu un ou deux enfants. On a utilisé la méthode du croisement en
un point, du croisement en deux points et du croisement uniforme.

Enfin, la mutation (ou l'apport de matériel génétique inédit d'une façon ou d'une
autre) a joué un rôle déterminant pour éviter à nos algorithmes de tomber dans
un extremum local.

En résumé, on a abordé pas mal de choses. Mais ce n'est que la surface
de l'iceberg.

Pour les articles à venir, je pense me pencher sur le
[problème des 8 dames](http://fr.wikipedia.org/wiki/Probl%C3%A8me_des_huit_dames).
Ça permettra de voir une autre façon de coder un chromosome et aussi de
confronter les classes développées dans les derniers articles à un
problème bien différent. Ensuite, j'aimerais résoudre un problème visuel.
Du genre : «Si je dispose de 1000 carrés de taille et de couleur quelconque,
quelle est la meilleure disposition pour s'approcher au mieux d'une
image donnée ?». C'est typiquement le genre de problème qui pourrait
tourner dans les navigateurs et être codé en Javascript. Avez-vous
d'autres idées/envies pour la suite ?

À demain.

{% connexe %}

