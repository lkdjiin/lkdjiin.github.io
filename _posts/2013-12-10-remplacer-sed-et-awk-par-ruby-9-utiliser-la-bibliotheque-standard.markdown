---
layout: post
title: "Remplacer Sed et Awk par Ruby: 9 Utiliser la bibliothèque standard"
date: 2013-12-10 18:40
legacy: true
tags: [sed, awk, ruby, débutant]
---



Se servir de Ruby pour remplacer Sed et Awk permet, entre autre, d'avoir accès
à la bibliothèque standard de Ruby (et même à n'importe quelle gem).  Pour un
script on peut charger les bibliothèques néccessaires dans un bloc BEGIN (avec
`require`), mais pour un *one liner*, ce serait beaucoup moins drôle. Ruby
permet de charger une gem sur la ligne de commande avec `-r`, une syntaxe plus
courte que `require`.

<!-- more -->

Tout au long de [cette série](http://lkdjiin.github.io/blog/2013/11/29/remplacer-sed-et-awk-par-ruby/), les exemples ont été triviaux et ça sera
encore le cas aujourd'hui. Prenons le fichier de données suivant:

{% highlight raw %}
1
2
3
2
3
4
{% endhighlight %}

L'objectif est d'afficher les différentes valeurs, **sans doublons**.
Pour le fichier ci-dessus, on veut donc obtenir: 1, 2, 3 et 4. Il y a plusieurs
solutions pour réaliser ça, l'une d'elles est d'utiliser [les sets](http://ruby-doc.org/stdlib-2.0.0/libdoc/set/rdoc/Set.html)
fournis par la bibliothèque standard de Ruby.

Voici une ligne de commande qui réalise l'objectif:

{% highlight bash %}
[~]⇒ ruby -nl -rset -e 'BEGIN{s=Set.new};s.add($_);END{p s}' data.txt
#<Set: {"1", "2", "3", "4"}>
{% endhighlight %}

Le switch `-n` passe Ruby en *mode sed/awk*. Le switch `-l` s'occupe des
caractères de fin de ligne.

Le switch `-r` va charger la gem passée en argument. Donc `-rset` va charger
la gem «set».

Pour ce qui est du script, on commence par initialiser une variable `s` en
tant qu'objet Set:

    BEGIN { s = Set.new }

Puis on ajoute le contenu de chaque ligne dans ce set (comme il s'agit
justement d'un type Set, les doublons ne seront pas pris en compte):

    s.add($_)

Enfin, on affiche le résultat, `p s` étant un raccourci pour
`puts s.inspect`. Les raccourcis sont les bienvenus pour les *one liners*:

    END { p s }





À demain.



