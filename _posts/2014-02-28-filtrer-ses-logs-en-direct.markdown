---
layout: post
title: "Filtrer ses logs en direct"
date: 2014-02-28 20:50
legacy: true
tags: [intermédiaire, linux, os x, log, terminal, tail, sed]
---



Aujourd'hui on voit comment filtrer nos fichiers de log en direct à l'aide
des commandes UNIX `tail` et `sed`.

<!-- more -->

Pour afficher un fichier en direct live sur le terminal, autrement dit pour
visualiser au fur et à mesure les ajouts dans ce fichier, on utilise
`tail -f`:

{% highlight bash %}
tail -f un/fichier/de/log
{% endhighlight %}

Pour afficher **uniquement** les lignes d'un fichier qui contiennent la
chaîne de caractères `ERROR`, on va utiliser `sed`:

{% highlight bash %}
sed -n '/ERROR/p' un/fichier/de/log
{% endhighlight %}

Ou bien pour afficher toutes les lignes d'un fichier **sauf** celles qui
contiennent la chaîne de caractères `bruit`, on utilisera:

{% highlight bash %}
sed '/bruit/d' un/fichier/de/log
{% endhighlight %}

Et en combinant les deux, on aura un log en direct et filtré:

{% highlight bash %}
tail -f un/fichier/de/log | sed -n '/ERROR/p'
{% endhighlight %}

Et vous, vous utilisez quelle(s) commande(s) ?



À demain.



