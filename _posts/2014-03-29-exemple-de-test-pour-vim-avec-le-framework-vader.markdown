---
layout: post
title: "Exemple de test pour Vim avec le framework Vader"
date: 2014-03-29 21:10
legacy: true
tags: [vim, test, plugin, framework, vader]
---



Pour mon plugin [QuickMarkdown](https://github.com/lkdjiin/quickmarkdown), je vais ajouter une petite fonction
qui insère la ligne `<!-- more -->` quand je tape la combinaison de
touche `<Leader>qm`. Ça devrait m'être utile vu que j'écris du markdown
pour Octopress tous les jours ;) Si on est pas obligé de passer par un
plugin pour ce genre de chose, ça va aussi me permettre de parler un peu
de Vader. Voici donc un exemple simple de TDD pour
Vim, avec le framework de test Vader.

<!-- more -->

Tout d'abord, j'écris le test:

{% highlight raw %}
Given (some text):
  First line
  Last line

Do (insert more marker in normal mode):
  gg
  :QuickMarkdownMore\<Enter>

Expect (marker inserted):
  First line
  <!-- more -->
  Last line
{% endhighlight %}

Voici comment il fonctionne. La directive `Given` produit un buffer (=~ fichier)
utilisé dans les directives suivante, qui contient 2 lignes, respectivement
`First line` et `Last line`:

{% highlight raw %}
Given (some text):
  First line
  Last line
{% endhighlight %}

Ensuite, la directive `Do` joue des commandes en mode normal. Tout d'abord
`gg`, pour s'assurer qu'on est sur la première ligne, puis la commande
`QuickMarkdownMore`, qui est celle qui est censée faire le travail:

{% highlight raw %}
Do (insert more marker in normal mode):
  gg
  :QuickMarkdownMore\<Enter>
{% endhighlight %}

Finalement, la directive `Expect` s'assure que le buffer de test a été
transformé comme je le voulais:

{% highlight raw %}
Expect (marker inserted):
  First line
  <!-- more -->
  Last line
{% endhighlight %}

Il reste à lancer le test (avec `:Vader`) pour s'assurer qu'il ne passe
pas, puis à écrire la fonction, et relancer le test en s'assurant qu'il
passe bien cette fois-ci.

Et voici pour finir le code d'implémentation:

{% highlight vim %}
command! QuickMarkdownMore call quickmarkdown#more()
{% endhighlight %}

{% highlight vim %}
function! quickmarkdown#more()
  call append('.', "<!-- more -->")
endfunction
{% endhighlight %}



À demain.




