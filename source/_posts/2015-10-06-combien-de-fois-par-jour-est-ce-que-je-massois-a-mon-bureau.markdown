---
layout: post
title: "Combien de fois par jour est-ce-que je m'assois à mon bureau"
date: 2015-10-06 12:50
comments: true
categories: [data science, projet]
---

Depuis le 21 septembre j'enregistre chaque jour les moments où je suis assis à
mon bureau. Je vais mener cette expérience un peu bizarre pendant encore quelques
semaines. Je voudrais savoir combien de fois par jour je m'assois à mon bureau,
et si certains patterns se dégagent. J'enregistre ces données avec un arduino
relié à un
[capteur de pression FSR](http://www.interlinkelectronics.com/FSR406.php).
Vous trouverez [le code arduino et quelques photos](https://github.com/lkdjiin/sit-down)
sur Github.

Cet article est un compte-rendu de la première semaine d'enregistrement.

{% img center /images/raw.jpg %}

<!-- more -->

La pression est enregistrée sur une échelle allant de 0 à 1023. Zéro
représentant l'absence de pression et 1023 étant la pression maximale que le
dispositif peut mesurer. Je fais une mesure toutes les 30 secondes.

Sur le graphique précédent, à gauche, on peut voir les données brutes de la
semaine. Toute l'échelle des valeurs est représentée. Suivant comment je suis
assis sur mon fauteuil, comment le poids est réparti, le dispositif capte des
valeurs différentes. Les points bleus, en bas, indiquent clairement quand je
suis assis. Après quelques essais empiriques, j'ai trouvé que la valeur 20
était un bon seuil pour séparer les données brutes en deux catégories :
assis (*seated*) et pas assis (*not seated*).

Voici le résultat pour la première semaine :

    | Jour       | Combien de fois assis |
    | ---------- | --------------------- |
    | 2015-09-21 | 32                    |
    | 2015-09-22 | 30                    |
    | 2015-09-23 | 33                    |
    | 2015-09-24 | 33                    |
    | 2015-09-25 | 40                    |
    | 2015-09-26 | 26                    |
    | 2015-09-27 | 26                    |

On peut visualiser les données retravaillées de manière sympathique, par
exemple pour le lundi ; les périodes de couleur marron sont les périodes
durant lesquelles je suis assis à mon bureau :

{% img center /images/visualize-day.png %}

On peut étendre ce genre de visualisation sur une semaine entière. C'est un
premier moyen pour repérer des patterns. Mais cette semaine ayant été spéciale
(*j'ai travaillé aussi le week-end, ce que je ne fait pas normalement*),
j'attendrai d'avoir récolté plus de données avant de tirer des conclusions.

{% img center /images/visualize-week.png %}

J'écrirai certainement un prochain article plus technique sur le code R qui a
été nécessaire pour traiter les données et obtenir ces graphiques.

Si vous avez des projets de ce genre, en tête ou en cours de réalisation,
j'aimerais beaucoup en entendre parler, alors n'hésitez pas à laisser votre
commentaire.

{% connexe %}
