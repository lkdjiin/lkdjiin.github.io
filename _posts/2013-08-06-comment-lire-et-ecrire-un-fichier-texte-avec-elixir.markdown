---
layout: post
title: "Comment lire et écrire un fichier texte avec Elixir"
date: 2013-08-06 08:43
legacy: true
tags: [elixir]
---


Quand j'aborde un nouveau langage j'aime bien regarder l'API pour les
entrées/sorties. Je trouve que ça donne le ton.
Aujourd'hui on voit comment ouvrir, lire et écrire des fichiers texte.

<!-- more -->

Lire un fichier
---------------

{% highlight elixir %}
{result, device} = File.open("file.ext", [:read, :utf8])
data = IO.read(device, :line)
File.close(device)
{% endhighlight %}

`result` contiendra `:ok` ou `:error`. On peut tester ce résultat après
coup ou bien se servir du
[pattern matching](http://lkdjiin.github.io/blog/2013/07/28/pattern-matching-avec-elixir-une-premiere-approche/) ainsi:

{% highlight elixir %}
{:ok, device} = File.open("file.ext", [:read, :utf8])
{% endhighlight %}

Lorsque la fin du fichier est atteinte, `IO.read` retourne `:eof`.
Si on veut lire un certain nombre de caractères au lieu d'une ligne
complète, on passe le nombre de caractères à lire à la fonction `IO.read`:

{% highlight elixir %}
chars = IO.read(device, 3)
{% endhighlight %}

On notera qu'il faut penser à fermer le fichier après utilisation, ce que
je trouve toujours bizarre avec un langage moderne. J'attends vraiment que
le runtime fasse ça pour moi.

Écrire un fichier
-----------------

{% highlight elixir %}
{:ok, device} = File.open("test", [:write, :utf8])
IO.write(device, "foo\n")
IO.puts(device, "bar")
File.close(device)
{% endhighlight %}

Pas grand chose à dire, c'est clair. La seule différence entre `IO.write`
et `IO.puts` est que cette dernière ajoute le caractère de fin de ligne.

Les entrées/sorties console
---------------------------
Pour lire sur la console on utilise `IO.gets`. Le *device* est `:stdio`
par défaut:

{% highlight iex %}
iex(46)> str = IO.gets(:stdio, "Votre nom: ")
Votre nom: xavier
"xavier\n"
iex(47)> str = IO.gets("Votre nom: ")        
Votre nom: foobar
"foobar\n"
{% endhighlight %}

Pour écrire sur la console on utilise `IO.puts`, mais ça vous le saviez déjà.

{% highlight iex %}
iex(48)> IO.puts(:stdio, str)        
foobar

:ok
iex(49)> IO.puts(str)        
foobar

:ok
{% endhighlight %}

Pour finir
----------
Voilà, c'est suffisant pour commencer à bidouiller. Pour aller plus loin,
on pourra lire la documentation des modules IO et File, qui permettent de
faire bien d'autres choses…





À demain.


