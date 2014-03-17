---
layout: post
title: "Vim - un plugin pour markdown - partie 3"
date: 2014-03-17 21:05
comments: true
categories: [vim, débutant, markdown, plugin, bépo]
---

{% level 2 %}

J'ai ajouté les titres de niveau 2 et 3, nettoyer un peu le code et
et remplacer l'utilisation des commandes en mode normal `yy` et `p`
(qu'un utilisateur peut toujours avoir remappé) par des fonctions
d'évaluations:

<!-- more -->

``` vim
function s:build_title(char)
  let s:line_content = substitute(getline("."), '.', a:char, 'g')
  call append('.', s:line_content)
endfunction

function! quickmarkdown#title1()
  call s:build_title("=")
endfunction

function! quickmarkdown#title2()
  call s:build_title("-")
endfunction

function! quickmarkdown#title3()
  call setline(line('.'), '### ' . getline('.'))
endfunction
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

