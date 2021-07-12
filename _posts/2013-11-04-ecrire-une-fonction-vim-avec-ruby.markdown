---
layout: post
title: "Écrire une fonction Vim avec Ruby"
date: 2013-11-04 17:01
legacy: true
tags: [vim, ruby]
---



Parfois, pas besoin de faire appel à un plugin, une simple petite fonction
suffit pour ce qu'on veut faire. Mais il faut avouer que le Vim Script est
un langage qui est loin de faire l'unanimité. Si on pouvait faire appel
à Ruby (ou Python, etc) pour écrire en partie nos fonctions Vim, ce serait
cool, non ?

<!-- more -->

Un cas d'utilisation simple
---------------------------
Prenons un cas habituel: supprimer les espaces en fin de ligne dans tout un
fichier. Pour cela il nous suffit d'écrire directement dans Vim:

{% highlight vim %}
:%s/\s\+$//
{% endhighlight %}

Mouais… Ça fonctionne, c'est sûr. Mais j'ai deux petits problèmes:

1. Je ne veux pas taper ça à chaque fois, parce qu'il faut que je me
   concentre un minimum pour bien écrire une regex, même si là y a pas
   de quoi fouetter un chat. En même temps, ça ne vaut pas le coup
   d'écrire un plugin juste pour ça.
2. Y'a rien à faire, je ne me rappelle jamais comment fonctionnent les
   regex Vim, quels sont les méta-caractères et tout et tout. 9 fois
   sur 10 j'oublierais par exemple d'échapper le `+`.

Une fonction Vim
-----------------
Si ça ne vaut pas un plugin, ça vaut bien une petite fonction à mettre,
par exemple, dans son `.vimrc`:

{% highlight vim %}
function RemoveTrailingSpaces()
  %s/\s\+$//
endfunction
{% endhighlight %}

Maintenant, on peut appeler notre fonction ainsi:

{% highlight vim %}
:call RemoveTrailingSpaces()
{% endhighlight %}

Ou bien la mapper sur une touche, si on l'utilise souvent:

{% highlight vim %}
map <Leader>r :call RemoveTrailingSpaces()<Enter>
{% endhighlight %}

Premier problème réglé, au suivant.

Utiliser Ruby dans une fonction Vim
-----------------------------------
Il faut bien sûr que votre Vim ait été compilé avec le support de Ruby.
Pour le savoir vous pouvez taper la ligne suivante dans votre console,
si "+ruby" s'affiche, c'est bon:

{% highlight bash %}
[~]⇒ vim --version | grep --color -i \+ruby
+printer +profile +python -python3 +quickfix +reltime +rightleft +ruby 
{% endhighlight %}

Voilà ce que donnerait notre fonction en utilisant Ruby:

{% highlight vim %}
function RemoveTrailingSpaces()
  rubydo gsub /\s+$/, ''
endfunction
{% endhighlight %}

C'est tout, `rubydo` suivi de l'instruction en Ruby !  Et vous, vous auriez des
petites astuces de ce genre à partager ?





À demain.



