---
layout: post
title: "Sed - Remplacer la n-ième occurence"
date: 2014-02-25 21:10
legacy: true
tags: [intermédiaire, unix, sed, texte, éditeur]
---

J'adore Sed. Je l'utilise depuis de longues années. Et pourtant je n'avais
jamais remarqué qu'on pouvait remplacer la n-ième occurence d'un pattern
dans une ligne.

<!-- more -->

Soit le fichier `test` suivant:

    Bonjour le monde !

Pour remplacer le premier `o` par un `-`:

{% highlight bash %}
sed 's/o/-/' test
{% endhighlight %}

Pour remplacer tous les `o` par des `-`:

{% highlight bash %}
sed 's/o/-/g' test
{% endhighlight %}

Pour remplacer le deuxième `o` par un `-`:

{% highlight bash %}
sed 's/o/-/2' test
{% endhighlight %}

Sed, c'est magique !



À demain.




