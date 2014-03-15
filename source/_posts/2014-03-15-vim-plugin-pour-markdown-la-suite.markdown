---
layout: post
title: "Vim - plugin pour markdown - la suite"
date: 2014-03-15 20:24
comments: true
categories: [vim, débutant, markdown, plugin, bépo]
---

L'embryon de plugin Vim pour les titres en markdown écrit
[la dernière fois](/blog/2014/03/12/vim-un-plugin-minimal-pour-les-titres-markdown/)
ne me satisfait pas du tout. En effet, il ne fonctionne pas avec ma
configuration personnelle, adapté pour le clavier bépo.

<!-- more -->

La fonction pour faire un titre était la suivante:

``` vim autoload/quickmarkdown.vim
function! quickmarkdown#title1()
  execute "normal yypVr="
endfunction
```

Chez moi, la touche pour la fonction de remplacement n'est pas `r`, mais `h`.
Voici donc une nouvelle fonction qui devrait marcher pour tout type de
configuration (enfin j'espère):

``` vim autoload/quickmarkdown.vim
function! quickmarkdown#title1()
  execute "normal yyp"
  execute ":s/./=/g"
endfunction
```

Plutôt que de remplacer la ligne avec `Vr=`, on la remplace avec une
substitution. Pour être *vraiment* utilisable partout, il me reste à
trouver comment me passer du `yyp` pour dupliquer une ligne, histoire
que ça fonctionne même si vous avez remappé `y` ou `p`…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

