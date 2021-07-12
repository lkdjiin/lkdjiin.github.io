---
layout: post
title: "Vim - Débarassez vous des buffers inutilisés"
date: 2014-03-08 20:37
legacy: true
tags: [vim, intermédiaire, buffer, onglet, fenêtre]
---



J'avais envie d'écrire un truc comme ça depuis quelques mois déjà.
Un plugin pour effacer tous les buffers inutilisés. Mais comme je ne
m'en servirais que 3 ou 4 fois par mois, et encore, j'ai toujours remis à
plus tard.

Quoiqu'il en soit, on l'a fait à ma place, parfait.

<!-- more -->

Le plugin
[Wipeout](http://www.vim.org/scripts/script.php?script_id=4882)
permet de supprimer tous les buffers qui ne sont pas liés à une
fenêtre, ni à un onglet. On l'appelera comme ça:

    :Wipeout

Si vous n'utilisez pas les onglets, [@madx](https://twitter.com/madx) en
a écrit un similaire qui supprimera les buffers qui ne sont pas affichés
(et donc du même coup les onglets autres que le courant):
[CleanBuffers](https://github.com/madx/vim-plugins/blob/master/plugin/clean-buffers.vim).
On le lancera avec:

    :CleanBuffers



À demain.



