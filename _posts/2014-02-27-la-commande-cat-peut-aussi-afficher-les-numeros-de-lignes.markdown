---
layout: post
title: "La commande cat peut aussi afficher les numéros de lignes"
date: 2014-02-27 20:48
legacy: true
tags: [débutant, linux, terminal, cat]
---



Je crois bien que je n'avais jamais regardé la documentation de la commande
unix `cat` jusqu'à il y a quelques jours. Je viens donc tout juste
d'apprendre qu'on pouvait afficher les numéros de lignes.

<!-- more -->

Afficher un fichier avec `cat`:

{% highlight bash %}
$ cat exemple
Je suis
un fichier
exemple.
{% endhighlight %}

Afficher avec les numéros de ligne:

{% highlight bash %}
$ cat -n exemple
     1	Je suis
     2	un fichier
     3	exemple.
{% endhighlight %}

Voilà, ça peut servir de temps en temps…



À demain.



