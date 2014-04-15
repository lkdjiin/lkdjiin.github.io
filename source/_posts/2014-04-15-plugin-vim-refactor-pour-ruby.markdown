---
layout: post
title: "Plugin vim-refactor pour Ruby"
date: 2014-04-15 21:23
comments: true
categories: [débutant, vim, plugin, ruby, refactoring]
---

{% level 1 %}

Voici un plugin Vim issu d'une expérience qu'on mène avec un collègue:
[vim-refactor](https://github.com/lkdjiin/vim-refactor).
Il fonctionne pour l'instant sur du code Ruby et permet d'extraire une
méthode.

<!-- more -->

À partir de ce genre de code:

``` ruby
class HelloWorld

  def greet
    greeting = "Hello World!"
    puts greeting
  end

end
```

En étant positionné sur la ligne 4, et en appelant `:ExtractMethod`
(ou bien sûr un mapping quelconque) vous obtenez ceci:

``` ruby
class HelloWorld

  def greet
    puts greeting
  end

  def greeting
    "Hello World!"
  end
end
```

C'est vraiment une version *alpha*. On espère implémenter d'autres types
de refactoring et supporter d'autres langages.


<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

