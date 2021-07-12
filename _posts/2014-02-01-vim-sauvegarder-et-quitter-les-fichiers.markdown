---
layout: post
title: "Vim - Sauvegarder et quitter les fichiers"
date: 2014-02-01 20:12
legacy: true
tags: [vim, intermédiaire, fichier]
---



Il est temps pour moi de faire un point sur les différentes méthodes
qu'offre Vim pour quitter et/ou sauvegarder un fichier.

<!-- more -->

Les basiques
------------

Voici, selon moi, les commandes à retenir en premier lieu.

Pour sauvegarder un fichier, utilisez la commande `write`, ou
plutôt son raccourci `w`:

    :w
    :write

Je rappelle qu'on peut facilement obtenir une aide exhaustive sur une
commande quelconque:

    :h :write

Et je conseille de lire systématiquement l'aide de Vim sur les
commandes dont je vais vous parler. Vous découvrirez ainsi des tas
de variantes qui pourrait vous être utile.

Pour sauvegarder tous les fichiers en une seule fois:

    :wall

Pour quitter un fichier, on utilise `quit`, ou son raccourci `q`:

    :q
    :quit

De même, pour quitter tous les fichiers (et fermer Vim):

    :qa
    :qall

Si vous voulez fermer un fichier modifié *sans* enregistrer les
modifications, la commande suivante est indispensable:

    :q!

Voilà pour les basiques. Ces commandes sont simples à mémoriser.

Les combinaisons
----------------

Il arrive souvent qu'on veuille sauvegarder un fichier, *et en même
temps* le fermer. Je recommenderais aux débutants d'utiliser la
commande suivante:

    :wq

Elle est très facile à mémoriser, étant la combinaison de `write` et
de `quit`.

Quand du temps aura passé et que vous serez prêt à en apprendre
d'autres, essayez donc les deux qui suivent:

Un simple `:x` permet de sauver/quitter le fichier, vous gagnez une
touche par rapport à `:wq`:

    :x

Suivant le layout de votre clavier, la suivante peut vous convenir plus ou
moins. C'est la seule qui soit en mode normal et non pas en mode commande,
rapide comme l'éclair, je l'adore:

    ZZ




À demain.


