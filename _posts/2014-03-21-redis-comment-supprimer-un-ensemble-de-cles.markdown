---
layout: post
title: "Redis - Comment supprimer un ensemble de clés"
date: 2014-03-21 21:44
legacy: true
tags: [redis, intermédiaire, base de données, bash]
---



Tiens, mon premier article sur Redis ! Normal, c'est une technologie que
j'ai découvert il y a peu…

<!-- more -->

Pour supprimer une clé dans Redis, on se connecte et on utilise la commande
`del`:

    $ redis-cli
    > del "nom:de:la:clef"

Mais quand on a des dizaines/centaines de clés, bof… Bien souvent (toujours
même ça vaut mieux) le nom des clés suit un motif. Par exemple:

    "motif:foo"
    "motif:bar"
    "motif:baz"
    etc...

Dans ce cas on peut utiliser Bash pour s'en sortir rapidement:

{% highlight bash %}
redis-cli keys "*motif*" | xargs redis-cli del
{% endhighlight %}

Et voilà, au revoir toutes les clés.



À demain.




