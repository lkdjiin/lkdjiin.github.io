---
layout: post
title: "Remplacer Sed et Awk par Ruby"
date: 2013-11-29 18:31
legacy: true
tags: [sed, awk, ruby]
---



Sed et Awk sont deux petits langages spécialisés dans l'édition, le
traitement, l'analyse, le filtrage, etc, des fichiers texte.
Ce que peuvent faire ces deux langages, Ruby peut le faire.

<!-- more -->

Dans mon [article précédant](http://lkdjiin.github.io/blog/2013/11/28/vim-plier-folder-les-commentaires-de-style-unix/)
j'ai écrit:

{% blockquote %}
le fichier https://github.com/ruby/ruby/blob/trunk/lib/csv.rb de
Ruby contient à ce jour 46% de lignes qui sont des commentaires.
{% endblockquote %}

Je n'ai bien sûr pas compté chaque commentaire du fichier. J'ai écrit pour
cela un petit script Ruby.

Un algorithme standard pour ce type de tâche serait:

    ouvrir le fichier
    initialiser des variables

    pour chaque ligne du fichier
        mettre à jour des variables
    fin

    fermer le fichier
    calculer le résultat
    afficher le résultat

En fait, quand on traite/édite/analyse/filtre un fichier texte, un pattern
basique apparait:

    ouvrir le fichier
    pour chaque ligne du fichier
        # faire un truc
    fin
    fermer le fichier

Avec Sed et Awk, l'ouverture du fichier, sa fermeture et la boucle de
traitement sont *implicites*. Autrement dit, on n'écrit jamais ce code.
On écrit seulement le code du traitement.

Ruby peut faire cela.

Une question se pose alors :
si Sed et Awk sont faits pour ça, pourquoi utiliser Ruby à la place ?
Il y a plusieurs raisons possibles:

- Vous ne connaissez ni Sed, ni Awk mais vous connaissez déjà Ruby,
  même un peu. Pourquoi apprendre un nouveau langage ?
- Vous pratiquez Sed et Awk et vous trouvez la syntaxe … comment dire …
  ésotérique (surtout celle de Sed).
- Utiliser Ruby permet d'avoir accès à toutes ses bibliothèques.

Convaincu ? Dans ce cas surveillez ce blog, je vais rapidement écrire
quelques articles sur ce sujet.





À demain.



