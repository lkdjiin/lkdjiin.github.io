---
layout: post
title: "Plugin vim-refactor pour Ruby"
date: 2014-04-15 21:23
legacy: true
tags: [débutant, vim, plugin, ruby, refactoring]
---



Voici un plugin Vim issu d'une expérience qu'on mène avec un collègue:
[vim-refactor](https://github.com/lkdjiin/vim-refactor).
Il fonctionne pour l'instant sur du code Ruby et permet d'extraire une
méthode.

<!-- more -->

À partir de ce genre de code:

{% highlight ruby %}
class HelloWorld

  def greet
    greeting = "Hello World!"
    puts greeting
  end

end
{% endhighlight %}

En étant positionné sur la ligne 4, et en appelant `:ExtractMethod`
(ou bien sûr un mapping quelconque) vous obtenez ceci:

{% highlight ruby %}
class HelloWorld

  def greet
    puts greeting
  end

  def greeting
    "Hello World!"
  end
end
{% endhighlight %}

C'est vraiment une version *alpha*. On espère implémenter d'autres types
de refactoring et supporter d'autres langages.




À demain.



