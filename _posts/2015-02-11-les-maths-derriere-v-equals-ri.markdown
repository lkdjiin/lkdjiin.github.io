---
layout: post
title: "Les maths derrière V=RI"
date: 2015-02-11 11:22
legacy: true
tags: [math, débutant, arduino]
---



\\(V = RI\\), la formule est simple. V pour le voltage (en Volts), R pour la
résistance (en Ohms) et I pour l'intensité (en Ampères).  Grâce à elle nous
pouvons calculer l'ampérage si nous connaissons le voltage et la résistance:

{% math %}
  I= \frac{V}{R}
{% endmath %}

Et nous pouvons aussi calculer la résistance si nous connaissons le voltage et
l'intensité:

{% math %}
  R= \frac{V}{I}
{% endmath %}

Pas besoin d'être fort en math pour pouvoir appliquer ces 3 formules. On a
juste à faire une multiplication, ou bien une division. Mais si on veut
comprendre pourquoi les deux dernières formules *découlent* de la première, il
faut un minimum de bagage en math.

**Cet article est pour celles et ceux qui ont séchés les cours de math au
collège** et qui voudraient maintenant comprendre pourquoi \\(V = RI\\) implique
nécessairement \\(I = V / R\\). Je vais tâcher de tirer et d'expliquer tous les
fils qui nous amène à déduire la seconde formule à partir de la première.

{% img center /images/math.jpg %}

<!-- more -->

Le symbole de la multiplication
-------------------------------

Le plus simple d'abord, \\(RI\\) est la multiplication de R par I.
Donc \\(RI\\) est la même chose que \\(R \times I\\).
Pour simplifier les choses (*ironie…*) on peut aussi
écrire le signe le la multiplication avec un point.
Les 3 lignes suivantes sont donc équivalentes:

{% math %}
  RI            \\
  R \times I    \\
  R \cdot I
{% endmath %}

L'égalité
---------

Parlons maintenant du signe `=`. Il signifie qu'on a une égalité entre ce qui
se trouve à sa gauche et ce qui se trouve à sa droite. En d'autres termes, ce
qui est à gauche du signe `=` à la même valeur que ce qui est à sa droite.
Donc si V vaut 12 (c'est un exemple), alors R × I vaut
aussi exactement 12. Si je remplace V par 12 dans la formule, on voit bien que
RI vaut 12:

{% math %}
  12 = RI
{% endmath %}


Ça ne nous
dit pas combien vaut exactement R ni combien vaut exactement I mais on sait
que la multiplication de ces deux là vaut 12. On a peut-être R = 1 et I = 12, ou
encore R = 3 et I = 4. Tout est possible du moment que \\(R \times I = 12\\).

Cette dernière égalité ( \\(R \times I = 12\\) ) m'amène à préciser ceci:
\\(V = RI\\) est la
même chose que \\(RI = V\\). Si vous avez du mal à penser avec des lettres,
n'hésitez pas à les remplacer régulièrement par des nombres pour voir de quoi
ça a l'air. Par exemple, si on dit que V = 12, R = 3 et I = 4, on peut écrire:

{% math %}
  12 = 3 \times 4
{% endmath %}

Ou encore :

{% math %}
  3 \times 4 = 12
{% endmath %}

C'est bien la même chose.

Jouons avec l'égalité
---------------------

On peut faire subir aux deux cotés de l'égalité la même opération sans que cela
pose problème.

Par exemple on peut ajouter 1 de chaque coté:

{% math %}
  V + 1 = RI + 1
{% endmath %}

Essayons avec des nombres. Si V = 12, R = 3 et I = 4 :

{% math %}
12 + 1 &= 3 \times 4 + 1 \\
13 &= 12 + 1 \\
13 &= 13
{% endmath %}

Ça marcherait aussi avec une soustraction ou tiens, avec une multiplication:

{% math %}
V \times 2 &= R \times I \times 2 \\
12 \times 2 &= 3 \times 4 \times 2 \\
24 &= 12 \times 2 \\
24 &= 24
{% endmath %}

Et bien sûr, ça fonctionne aussi avec la division, tant qu'on divise par
autre chose que zéro:

{% math %}
V / 2 &= R \times I / 2 \\
12 / 2 &= 3 \times 4 / 2 \\
6 &= 12 / 2 \\
6 &= 6
{% endmath %}

Un truc intéressant à propos de la division
-------------------------------------------

Puisqu'on parle de division, voici un truc intéressant à propos de la division.
Quand on divise un nombre (n'importe lequel à part zéro) par lui-même on obtient toujours 1.
Toujours. Par exemple:

{% math %}
  12 / 12 = 1
{% endmath %}

Si on généralise : \\(A / A = 1\\). Donc c'est pareil avec R ou I :

{% math %}
  R / R &= 1 \\
  I / I &= 1
{% endmath %}

Division et fraction
--------------------

Jusqu'ici j'ai utilisé le signe `/` pour la division, mais celui-ci n'est pas
toujours très pratique et on le remplace souvent par une fraction. Et oui:
division et fraction c'est la même chose.

{% math %}
  X / Y= \frac{X}{Y}
{% endmath %}

Reprenons notre formule de base :

{% math %}
  V = R \times I
{% endmath %}

Si on divise les deux cotés par R, ça donne :

{% math %}
  \frac{V}{R}= \frac{R \times I}{R}
{% endmath %}

On y est presque, je vous assure ! Il faut encore comprendre une dernière chose :

{% math %}
  \frac{R \times I}{R}=I
{% endmath %}

Wait

{% img center /images/wut.jpg %}

Rappelez vous qu'une fraction, c'est la même chose qu'une division. Si je
généralise:

{% math %}
  \frac{X \times Y}{Z}=X \times Y / Z
{% endmath %}

Il faut aussi savoir qu'il n'y a pas de priorité entre la multiplication et
la division, ainsi \\(10 \times 2 / 5 = 4\\), tout aussi bien que
\\(10 / 5 \times 2 = 4\\) ou que \\(2 / 5 \times 10 = 4\\).

Donc :

{% math %}
  \frac{R \times I}{R}
{% endmath %}

Équivaut à :

{% math %}
  R \times I / R
{% endmath %}

Ce qui est exactement pareil que :

{% math %}
  R / R \times I
{% endmath %}

Et nous avons vu que `R / R` vaut 1, ce qui donne :

{% math %}
  1 \times I
{% endmath %}

Ou plus simplement :

{% math %}
  I
{% endmath %}

Conclusion
----------

Notre formule de base nous permet de calculer V à partir de R et de I:

{% math %}
  V = RI
{% endmath %}

On joue avec en divisant chaque coté par R:

{% math %}
  \frac{V}{R} = \frac{RI}{R}
{% endmath %}

Ce qui donne:

{% math %}
  \frac{V}{R} = I
{% endmath %}

Qu'on remet dans le bon sens si on préfère, on peut maintenant calculer I à
partir de V et R:

{% math %}
  I = \frac{V}{R}
{% endmath %}

Si nous avons un voltage de 5 Volts et une résistance de 1000 Ohms, combien
aurons nous d'ampères:

{% math %}
  I = \frac{5}{1000} = 0.005
{% endmath %}

Vous venez de déduire une formule mathématique à partir d'une autre et de
l'utiliser !
Et de rattraper plusieurs heures de sèche du collège en quelques minutes ;)

À plus tard.

{% include mathjax.html %}
