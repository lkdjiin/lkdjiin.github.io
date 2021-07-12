---
layout: post
title: "Comment mettre à jour un package R"
date: 2016-08-04 08:17
legacy: true
tags: [R]
---

Comment faire pour mettre à jour un seul package en R ? Pas deux, pas trois,
pas cinquante, non juste un. Allez, "ggplot2" par exemple. Ça devrait être
simple…

<!-- more -->

Je tape `?update<TAB>` et je vois qu'il existe une fonction `update.packages()`
Cette fonction semble prometteuse, n'est-ce-pas ?

Oubliez la ! Elle (`update.packages()`) va mettre à jour **tous** vos packages.
Et selon leur nombre cela peut prendre beaucoup de temps.

Pour mettre à jour un seul package on doit utiliser `install.packages()` comme ceci:

{% highlight r %}
install.packages("ggplot2")
{% endhighlight %}

Intuitif, non ? Il n'y a pas de différences entre l'installation et la mise à
jour.


