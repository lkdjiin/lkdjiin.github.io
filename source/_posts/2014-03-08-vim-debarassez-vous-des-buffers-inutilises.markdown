---
layout: post
title: "Vim - Débarassez vous des buffers inutilisés"
date: 2014-03-08 20:37
comments: true
categories: [vim, intermédiaire, buffer, onglet, fenêtre]
---

{% level 2 %}

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

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

