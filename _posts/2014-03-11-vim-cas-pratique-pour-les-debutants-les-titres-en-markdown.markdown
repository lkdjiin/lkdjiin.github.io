---
layout: post
title: "Vim - Cas pratique pour les débutants : les titres en markdown"
date: 2014-03-11 21:09
legacy: true
tags: [vim, débutant, markdown]
---



Vous débutez sur Vim ? Je vous propose aujourd'hui des exercices pratiques
pour définir des titres au format markdown.

<!-- more -->

Un titre de niveau 1 en markdown s'écrit comme ceci:

    Titre de niveau 1
    =================

On est pas obligé de mettre autant de `=` que de caractères dans le titre
(de mémoire je crois que 3 suffisent), mais c'est quand même agréable à
l'œil.

La suite de commandes pour obtenir ça est: `yypVr=`. On décortique:

- `yy` copie la ligne du titre dans un buffer.
- `p` affiche ce buffer sur la ligne du dessous et nous place sur cette
  nouvelle ligne.
- `V` passe cette nouvelle ligne en mode selection.
- `r=` remplace toute la selection par autant de `=`.

Pour les titres de niveau 2, on remplace le `=` par un `-`.

Voilà, la prochaine fois on en fera peut-être un plugin, allez savoir…

Et vous, vous faites comment ?



À demain.



