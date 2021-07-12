---
layout: post
title: "Vim - Un plugin minimal pour les titres markdown"
date: 2014-03-12 21:32
legacy: true
tags: [vim, débutant, markdown, plugin]
---



Hier on a vu [comment faire rapidement des titres au format markdown](/blog/2014/03/11/vim-cas-pratique-pour-les-debutants-les-titres-en-markdown/).
Aujourd'hui on transforme ça en plugin. Enfin, en un embryon de plugin.

<!-- more -->

Voici donc un plugin bricolé en deux minutes qui fait des titres de niveau 1
en markdown.

{% highlight vim %}
if exists('g:loaded_quickmarkdown') || &cp || v:version < 700
  finish
endif
let g:loaded_quickmarkdown = 1

command! QuickMarkdownTitle1 call quickmarkdown#title1()
{% endhighlight %}

{% highlight vim %}
function! quickmarkdown#title1()
  execute "normal yypVr="
endfunction
{% endhighlight %}

Et en mettant ce qui suit dans votre vimrc, on peut l'activer avec
leader puis `=`:

{% highlight vim %}
map<Leader>= :QuickMarkdownTitle1<Enter>
{% endhighlight %}

Quand j'aurais le temps j'ajouterais les niveaux 2, 3, 4, etc. Et aussi
la documentation et quelques explications ;)



À demain.



