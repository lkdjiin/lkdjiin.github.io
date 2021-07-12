---
layout: post
title: "Vim - Un plugin pour markdown - partie 8"
date: 2014-03-31 20:58
legacy: true
tags: [vim, débutant, markdown, plugin, vader]
---



On continue d'implémenter [la fonctionnalité commencée hier](/blog/2014/03/30/vim-un-plugin-pour-markdown-partie-7/)
en testant deux cas exceptionnels, toujours à l'aide de Vader.

<!-- more -->

Revoici le fichier de test d'hier:

{% highlight raw %}
Given (some text):
  abc def ghi jkl mno

Execute (starting in middle of a word):
  execute "normal! fe"
  QuickMarkdownItalic

Expect (2nd word in italic):
  abc *def* ghi jkl mno
{% endhighlight %}

Je vais ajouter deux tests. L'un pour voir ce qu'il se passe quand le
curseur se trouve au début d'un mot, et idem pour la fin d'un mot:

{% highlight raw %}
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
{% endhighlight %}

Et avec l'implémentation de la dernière fois:

{% highlight vim %}
function! quickmarkdown#italic()
  execute "normal! bi*\<Esc>ea*\<Esc>"
endfunction
{% endhighlight %}

… le test où le curseur se trouve au début d'un mot échoue
misérablement.

Pour le faire passer, on doit d'abord déplacer le curseur d'un cran
vers la droite:


{% highlight vim %}
function! quickmarkdown#italic()
  execute "normal! lbi*\<Esc>ea*\<Esc>"
endfunction
{% endhighlight %}

La prochaine fois on continue avec d'autres cas exceptionnels.



À demain.


