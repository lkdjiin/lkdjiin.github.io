---
layout: post
title: "Vim - plugin pour markdown - la suite"
date: 2014-03-15 20:24
legacy: true
tags: [vim, débutant, markdown, plugin, bépo]
---



L'embryon de plugin Vim pour les titres en markdown écrit
[la dernière fois](/blog/2014/03/12/vim-un-plugin-minimal-pour-les-titres-markdown/)
ne me satisfait pas du tout. En effet, il ne fonctionne pas avec ma
configuration personnelle, adapté pour le clavier bépo.

<!-- more -->

La fonction pour faire un titre était la suivante:

{% highlight vim %}
function! quickmarkdown#title1()
  execute "normal yypVr="
endfunction
{% endhighlight %}

Chez moi, la touche pour la fonction de remplacement n'est pas `r`, mais `h`.
Voici donc une nouvelle fonction qui devrait marcher pour tout type de
configuration (enfin j'espère):

{% highlight vim %}
function! quickmarkdown#title1()
  execute "normal yyp"
  execute ":s/./=/g"
endfunction
{% endhighlight %}

Plutôt que de remplacer la ligne avec `Vr=`, on la remplace avec une
substitution. Pour être *vraiment* utilisable partout, il me reste à
trouver comment me passer du `yyp` pour dupliquer une ligne, histoire
que ça fonctionne même si vous avez remappé `y` ou `p`…



À demain.



