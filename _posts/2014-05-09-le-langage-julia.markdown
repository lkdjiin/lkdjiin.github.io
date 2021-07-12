---
layout: post
title: "Le langage Julia"
date: 2014-05-09 21:27
legacy: true
tags: [intermédiaire, julia, programmation fonctionnelle]
---



Aujourd'hui j'ai commencé à jouer un peu (2 heures à peine) avec le langage
[Julia](http://julialang.org/).
Ça faisait longtemps que j'en avais envie et j'ai été enthousiasmé.

<!-- more -->

Je cherche un langage fonctionnel qui, entre autres,:

- ne soit pas *purement* fonctionnel.
- soit rapide.
- ai une syntaxe assez simple.

J'ai peut-être trouvé ça avec Julia. Cet après-midi j'ai installé la
version binaire sur OS X sans problème. En ce moment je suis en train de
la compiler sur Debian (c'est très long…).

J'en suis encore à faire le tour de la syntaxe en suivant
[cette introduction](http://learnxinyminutes.com/docs/julia/). J'en parlerais
plus quand j'aurais un peu avancé ;)

Deux/trois trucs que j'ai retenu:

L'operateur de division est logiquement:

{% highlight julia %}
5 / 2 # => 2.5
{% endhighlight %}

Mais plus surprenant (pour moi en tous cas):

{% highlight julia %}
2 \ 5 # => 2.5
{% endhighlight %}

J'ai hâte de savoir si il y a une utilité à ça ;)

J'ai eu aussi plaisir à retrouver une arithmétique binaire, par exemple
la multiplication par 2:

{% highlight julia %}
8 << 1 # => 16
{% endhighlight %}

Dernier truc, et je m'arrête là, j'aime quand les indices commencent à
1, et non pas à 0:

{% highlight julia %}
"Bonjour"[1] # => 'B'
{% endhighlight %}




À demain.



