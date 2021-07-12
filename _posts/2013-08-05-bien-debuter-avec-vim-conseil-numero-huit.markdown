---
layout: post
title: "Bien débuter avec Vim: conseil numéro huit"
date: 2013-08-05 08:53
legacy: true
tags: [vim]
---



N'utilisez pas (encore) de plugins
----------------------------------
*Ce conseil là, personne ne va le suivre…*

Très vite, au bout de quelques heures, au mieux quelques jours, vous allez
vouloir installer des plugins. La raison principale est
que vous voudrez vous sentir à l'aise avec Vim.
Et pour cela vous chercherez a reproduire (voir simuler) le
comportement de votre ex éditeur/EDI.
C'est normal, c'est humain, mais à mon avis c'est une erreur.

<!-- more -->

Un plugin est fait pour pallier un manque dans une application, pour l'étendre.
Or en tant que débutant, on n'est pas à même de savoir ce que Vim peut ou ne
peut pas faire pour nous. C'est pourquoi vous devriez attendre au moins un
mois avant d'installer votre
premier plugin. Pendant ce temps là, si quelque chose vous manque, cherchez le
dans l'aide de vim ou avec google. La plupart du temps vous finirez par trouver
une façon de faire *à la vim*.


Un simple exemple pour illustrer mon propos: commenter/décommenter quelques
lignes de code. C'est quelque chose qu'un développeur fait plusieurs fois
dans la journée. C'est une des premières fonctions qu'on apprend quand on
essaye un nouvel éditeur de code. Et tout apprenti Vimiste est très surpris,
voir même choqué, d'apprendre que Vim ne sais pas faire ça ! Le truc qu'il
faut se rentrer dans le crâne, c'est que {" Vim n'est pas un éditeur de
code. "}
C'est comme ça, il faut l'accepter. Vim est un éditeur point. Dès qu'il
comprend cela, l'apprenti Vimiste part en quête d'un plugin pour commenter
du code, le trouve facilement, l'installe et on en parle plus. En clair on
a rien appris sur Vim. Or en cherchant un peu on pourrait trouver ça pour
commenter un paragraphe (en étant placé n'importe où sur la 1ère ligne):


    ^<C-v>}I#<Esc>

Et ça pour décommenter:

    ^<C-v>}d<Esc>

Je vous accorde que ça n'est pas aussi agréable que d'utiliser un plugin,
mais ça marche. Et ça peut être utile quand on doit utiliser un Vim de base.





À demain.

