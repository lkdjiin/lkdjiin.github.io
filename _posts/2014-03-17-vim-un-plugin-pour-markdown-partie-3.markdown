---
layout: post
title: "Vim - un plugin pour markdown - partie 3"
date: 2014-03-17 21:05
legacy: true
tags: [vim, débutant, markdown, plugin, bépo]
---



J'ai ajouté les titres de niveau 2 et 3, nettoyer un peu le code et
et remplacer l'utilisation des commandes en mode normal `yy` et `p`
(qu'un utilisateur peut toujours avoir remappé) par des fonctions
d'évaluations:

<!-- more -->

{% highlight vim %}
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
{% endhighlight %}



À demain.



