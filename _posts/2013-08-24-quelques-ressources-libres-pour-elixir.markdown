---
layout: post
title: "Quelques ressources libres pour Elixir"
date: 2013-08-24 11:24
legacy: true
tags: [elixir]
---



J'ai passé quelques semaines à tester/jouer avec le langage Elixir. Voici
une liste des ressources qui m'ont été très utiles.

<!-- more -->

Le site officiel
----------------

Tout commence ici: [http://elixir-lang.org/](http://elixir-lang.org/).
Plus spécifiquement, vous y trouverez une liste de
[tutoriels](http://elixir-lang.org/getting_started/1.html)
bien foutus, quoique trop succints à mon goût.

La documentation
------------------
N'hésitez jamais à consulter la
[documentation d'Elixir](http://elixir-lang.org/docs/stable/). Elle est
claire et assez complète pour un jeune projet.

Études for Elixir
-----------------
[Études for Elixir](http://chimera.labs.oreilly.com/books/1234000001642)
est un bouquin par O'Reilly en open-source. Il s'agit d'une série d'exercices
à réaliser, on apprend beaucoup. Si vous êtes coincés, les solutions se
trouvent
[ici](https://github.com/oreillymedia/etudes-for-elixir).

La mailing list
---------------
Si vous êtes perdus, la [mailing list](https://groups.google.com/forum/#!forum/elixir-lang-talk)
d'Elixir est votre amie. L'auteur du langage, et d'autres passionnés/engagés,
vous répondent rapidement et poliment. Les réponses sont toujours pertinentes.
C'est vraiment une très bonne mailing list.


Plugin vim
----------
Si vous utilisez Vim, ce qu'il vous faut pour la syntaxe, l'indentation, etc,
se trouve [ici](https://github.com/elixir-lang/vim-elixir).

Si vous utilisez le plugin Vim Snipmate, voici en bonus un fichier de
snippets pour Elixir que j'ai commencé. Il y en a peu, mais je pense que
c'est un bon départ, à vous ensuite de créer les votres:

{% highlight vim %}
snippet case
	case ${1:var} do
		${2:condition1} -> ${3:action1}
		_ -> ${4:other}
	end
snippet cond
	cond do
		${1:condition1} -> ${2:action1}
		true -> ${3:other}
	end
snippet d
	def ${1:function} do
		${2}
	end
snippet dm
	defmodule ${1:ModuleName} do
		${2}
	end
snippet dp
	defp ${1:function} do
		${2}
	end
snippet map
	Enum.map(${1:list}, fn e -> ${2:action} end)
snippet puts
	IO.puts ${1}
{% endhighlight %}

Conclusion provisoire sur Elixir
---------------------------------
Apprendre les bases d'Elixir a été plaisant, mais je vais m'arrêter là,
du moins jusqu'à la sortie de la version 1.0.
Le gros avantage d'Elixir est d'utiliser la totalité de vos processeurs
gratuitement. Il n'y a rien à faire, rien à dire, rien à configurer. Ça
marche et c'est tout. J'ai moins aimé la syntaxe qui te fait croire que
tu es en terrain conquis si tu connais Ruby. Ça n'est pas le cas, les
deux langages sont vraiment différents. Le couplage avec Erlang ne
m'a pas convaincu. À un moment ou un autre (du moins quand j'écris ces
lignes) si on veut écrire quelque chose de conséquent, il faut apprendre
un minimum d'Erlang. Ça changera peut-être avec le temps.

Quoiqu'il en soit, la fréquence de nos processeurs n'augmentant plus, un
langage élégant qui sait *réellement* utiliser le multi-coeur simplement
et avec efficacité est sans conteste un langage sur lequel il faut
garder un oeil…





À demain.



