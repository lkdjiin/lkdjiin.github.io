---
layout: post
title: "Vim - Un plugin pour markdown - partie 7"
date: 2014-03-30 21:20
legacy: true
tags: [vim, débutant, markdown, plugin, vader]
---



Pour mon plugin Vim qui aide à écrire du markdown, j'ai envie d'une
fonctionnalité pour mettre un mot en italique (et aussi en gras).
Si j'ai le texte suivant:

    foo bar baz

et que le curseur est dans le mot `bar`, je veux que la combinaison de
touches `<Leader>qi` donne ceci:

    foo *bar* baz

Pour implémenter ça, j'utiliserais encore le framework de test Vader.

<!-- more -->

Voici un premier test, pour le cas général:

{% highlight raw %}
Given (some text):
  abc def ghi jkl mno

Execute (starting in middle of a word):
  execute "normal! fe"
  QuickMarkdownItalic

Expect (2nd word in italic):
  abc *def* ghi jkl mno
{% endhighlight %}

Le bloc `Execute` place d'abord le curseur sur le caractêre `e`,
autrement dit *à l'intérieur* du mot `def`. Il lance ensuite la fonction
`QuickMarkdownItalic` qui devra faire le travail.

Dans le fichier `plugin/quickmarkdown.vim`, j'ajoute la nouvelle
fonction:

{% highlight vim %}
command! QuickMarkdownItalic call quickmarkdown#italic()
{% endhighlight %}

Puis j'implémente la fonction de la manière la plus simple à laquelle
je puisse penser:

{% highlight vim %}
function! quickmarkdown#italic()
  execute "normal! bi*\<Esc>ea*\<Esc>"
endfunction
{% endhighlight %}

Décodage: `b` place le curseur au début du mot. `i*\<Esc>` passe en
mode insertion, ajoute un `*` et revient en mode normal. `e` place le
curseur à la fin du mot. `a*\<Esc>` passe en mode insertion *derrière*
le mot et ajoute un `*` puis revient encore en mode normal.

Cette fonction sera amenée à bouger une fois qu'on se sera occupé des
cas particuliers. Ce sera pour une prochaine fois.



À demain.


