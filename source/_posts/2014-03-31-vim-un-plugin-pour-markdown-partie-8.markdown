---
layout: post
title: "Vim - Un plugin pour markdown - partie 8"
date: 2014-03-31 20:58
comments: true
categories: [vim, débutant, markdown, plugin, vader]
---

{% level 1 %}

On continue d'implémenter [la fonctionnalité commencée hier](/blog/2014/03/30/vim-un-plugin-pour-markdown-partie-7/)
en testant deux cas exceptionnels, toujours à l'aide de Vader.

<!-- more -->

Revoici le fichier de test d'hier:

``` raw
Given (some text):
  abc def ghi jkl mno

Execute (starting in middle of a word):
  execute "normal! fe"
  QuickMarkdownItalic

Expect (2nd word in italic):
  abc *def* ghi jkl mno
```

Je vais ajouter deux tests. L'un pour voir ce qu'il se passe quand le
curseur se trouve au début d'un mot, et idem pour la fin d'un mot:

``` raw
Given (some text):
  abc def ghi jkl mno

Execute (starting in middle of a word):
  execute "normal! fe"
  QuickMarkdownItalic

Expect (2nd word in italic):
  abc *def* ghi jkl mno

Execute (starting at beginning of a word):
  execute "normal! fd"
  QuickMarkdownItalic

Expect (2nd word in italic):
  abc *def* ghi jkl mno

Execute (starting at the end of a word):
  execute "normal! ff"
  QuickMarkdownItalic

Expect (2nd word in italic):
  abc *def* ghi jkl mno
```

Et avec l'implémentation de la dernière fois:

``` vim autoload/quickmarkdown.vim
function! quickmarkdown#italic()
  execute "normal! bi*\<Esc>ea*\<Esc>"
endfunction
```

… le test où le curseur se trouve au début d'un mot échoue
misérablement.

Pour le faire passer, on doit d'abord déplacer le curseur d'un cran
vers la droite:


``` vim autoload/quickmarkdown.vim
function! quickmarkdown#italic()
  execute "normal! lbi*\<Esc>ea*\<Esc>"
endfunction
```

La prochaine fois on continue avec d'autres cas exceptionnels.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
