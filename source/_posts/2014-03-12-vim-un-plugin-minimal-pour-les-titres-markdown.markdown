---
layout: post
title: "Vim - Un plugin minimal pour les titres markdown"
date: 2014-03-12 21:32
comments: true
categories: [vim, débutant, markdown, plugin]
---

{% level 1 %}

Hier on a vu [comment faire rapidement des titres au format markdown](/blog/2014/03/11/vim-cas-pratique-pour-les-debutants-les-titres-en-markdown/).
Aujourd'hui on transforme ça en plugin. Enfin, en un embryon de plugin.

<!-- more -->

Voici donc un plugin bricolé en deux minutes qui fait des titres de niveau 1
en markdown.

``` vim plugin/quickmarkdown.vim
if exists('g:loaded_quickmarkdown') || &cp || v:version < 700
  finish
endif
let g:loaded_quickmarkdown = 1

command! QuickMarkdownTitle1 call quickmarkdown#title1()
```

``` vim autoload/quickmarkdown.vim
function! quickmarkdown#title1()
  execute "normal yypVr="
endfunction
```

Et en mettant ce qui suit dans votre vimrc, on peut l'activer avec
leader puis `=`:

``` vim
map<Leader>= :QuickMarkdownTitle1<Enter>
```

Quand j'aurais le temps j'ajouterais les niveaux 2, 3, 4, etc. Et aussi
la documentation et quelques explications ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

