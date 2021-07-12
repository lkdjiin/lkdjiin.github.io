---
layout: post
title: "Pourquoi je passe à Vundle"
date: 2014-03-14 20:53
legacy: true
tags: [vim, vundle, pathogen]
---

Je suis (j'étais) un utilisateur de [Pathogen](https://github.com/tpope/vim-pathogen), le plugin Vim pour gérer
les plugins Vim (!). De base, le système offert par Vim pour maintenir son
pool de plugin à jour est tellement exécrable qu'il faut bien un plugin
pour gérer ça ! En janvier dernier j'ai commencé à utiliser OS X au boulot,
et suite à quelques soucis, Pathogen refusait de fonctionner (pour être
honnête, ça n'était pas de sa faute). J'ai donc péniblement installé mes
plugins les plus importants à la main… avant d'essayer [Vundle](https://github.com/gmarik/Vundle.vim).

<!-- more -->

Et j'ai trouvé Vundle excellent. À tel point que je vais migrer ma configuration
à la maison ce week-end. Pourquoi je trouve Vundle meilleur que Pathogen ?

- BundleInstall installe le plugin tout seul comme un grand, et aussi la
  documentation.
- BundleInstall! met à jour les plugins.
- BundleClean désinstalle automatiquement les plugins inutilisés.

En un mot : **comfort**.

Bon, le système n'est pas parfait. Il manque quelque chose pour 
installer une révision particulière d'un plugin et je ne peux plus *hacker*
directement le code source quand un plugin me pose problème en bépo (mais c'est
pas plus mal de trouver une autre solution).

Et vous, vous utilisez quoi, et pourquoi, pour gérer vos plugins Vim ?



À demain.



