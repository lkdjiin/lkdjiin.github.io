---
layout: post
title: "Elixir et les paramètres par défaut"
date: 2013-08-07 08:46
comments: true
categories: [elixir, débutant]
---
{% level 1 %}

Pour définir un paramètre par défaut dans une fonction de module, Elixir
fournit l'opérateur `//`:

``` elixir test.exs
defmodule M do
  def foo(a // "a") do
    IO.puts(a)
  end
end

M.foo()
M.foo("z")
```

<!-- more -->

    $ elixir test.exs 
    a
    z

Beaucoup d'autres langages permettent la même chose, en général à l'aide
de l'opérateur d'affection `=`. Si Elixir utilise `//` à la place de `=`,
ça n'est pas par goût de l'étrange ou par snobisme. Avec Elixir l'opérateur
`=` fait plus que de l'affectation, `=` fait aussi du
[pattern matching](http://lkdjiin.github.io/blog/2013/07/28/pattern-matching-avec-elixir-une-premiere-approche/).
Et d'après ce que j'ai pu voir, le *pattern matching* est interdit dans
la définition des paramètres.

On peut bien sûr mixer paramètre *normal* et paramètre par défaut:

``` elixir test.exs
defmodule M do
  def foo(a, b // "b") do
    IO.puts "#{a} #{b}"
  end
end

M.foo("a")
M.foo("a", "z")
```

    $ elixir test.exs 
    a b
    a z

Encore une fois c'est comme avec un tas d'autres langages. On place les
paramètres par défaut à la fin. Mais Elixir va plus loin en permettant
de placer les paramètres par défaut n'importe où:

``` elixir test.exs
defmodule M do
  def foo(a // "a", b) do
    IO.puts "#{a} #{b}"
  end
end

M.foo("z")
```

    $ elixir test.exs 
    a z

C'est peut-être un classique de la programmation fonctionnelle, mais moi, c'est
la première fois que je vois ça. Je ne sais pas encore si c'est utile, mais
au moins c'est possible. Si vous connaissez d'autres langages qui permettent
ce truc, laissez moi un commentaire, je suis curieux.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.
{% connexe %}
