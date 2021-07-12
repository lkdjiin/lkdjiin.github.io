---
layout: post
title: "Un quine en R - Le retour"
date: 2015-10-13 14:19
legacy: true
tags: [R, quine, répliquant]
---

Dans l'article précédent [Un quine en R](http://lkdjiin.github.io/blog/2015/10/10/un-quine-en-r/)
je présentais un [quine](https://fr.wikipedia.org/wiki/Quine_%28informatique%29) en langage R. Le code était un peu long, 19 lignes,
surtout comparé au code Ruby de l'article original:

{% highlight ruby %}
src = "\nputs \"src = \" + src.inspect + src"
puts "src = " + src.inspect + src
{% endhighlight %}

En Ruby, c'est court en partie grâce à la méthode `inspect` qui *échappe*
automatiquement les caractères non imprimables et les guillemets:

<!-- more -->

{% highlight irb %}
>> foo = "\nputs \"src\""
"\nputs \"src\""
>> foo.inspect
"\"\\nputs \\\"src\\\"\""
{% endhighlight %}

Bien entendu j'ai cherché une fonction similaire en R, du moins pour les
chaînes de caractères. J'ai laissé tombé après un quart d'heure de recherches
infructueuses, et j'ai pondu [le code](http://lkdjiin.github.io/blog/2015/10/10/un-quine-en-r/) de l'article précédent.

C'est là que Hadley Wickham *himself* m'a suggéré l'utilisation de la fonction
`encodeString`. C'est ce que j'avais cherché sans le trouver. Du coup, un
quine en R prends beaucoup moins de place et deviens plus compréhensible:

{% highlight r %}
src <- "\nwriteLines(c(paste(\"src <-\", encodeString(src, quote='\"')), src))"

writeLines(c(paste("src <-", encodeString(src, quote='"')), src))
{% endhighlight %}

Cette version me plait bien, je l'ai donc ajouté sur le [rosettacode.org](http://rosettacode.org/wiki/Quine#R).

Comme dit la dernière fois, il est bon d'utiliser `diff` pour s'assurer qu'on
a bien écrit un quine:

{% highlight bash %}
diff -u quine2.r <(Rscript quine2.r)
{% endhighlight %}

Et voilà le résultat:

{% highlight raw %}
$ Rscript quine3.r
src <- "\nwriteLines(c(paste(\"src <-\", encodeString(src, quote='\"')), src))"

writeLines(c(paste("src <-", encodeString(src, quote='"')), src))
{% endhighlight %}


