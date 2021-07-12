---
layout: post
title: "Utiliser Vim comme un tableur sur Linux (enfin presque)"
date: 2013-11-24 20:55
legacy: true
tags: [vim, ruby, linux]
---



[Hier](http://lkdjiin.github.io/blog/2013/11/23/pourcentage-des-issues-par-langages-sur-github/) j'ai donné une liste des rapports issues/nombre de dépots
par langages sur Github. Aujourd'hui je montre comment j'ai utilisé
Vim (sur linux) pour calculer ce rapport et formater la liste.

<!-- more -->

Voici la liste de départ, à récupérer [ici](http://hubreports.yougeezer.co.uk/languages), il s'agit juste d'un
copier/coller de la page web et je n'ai pris ici que les 5 premiers,
c'est suffisant pour la démonstration:

    1 	JavaScript .js	560,116	891,531	319,537	4,951	1,147	343,483
    2 	Ruby .rb	466,411	469,913	175,577	2,726	607	147,339
    3 	Java .java	388,610	376,683	231,186	4,185	825	161,136
    4 	Python .py	281,835	323,858	130,034	2,538	685	184,908
    5 	PHP .php	275,411	289,899	155,941	2,331	454	150,024

Alors on n'y comprend rien puisque les colonnes sont invisibles. On va
former de belles colonnes à l'aide de l'utilitaire unix **column**:

{% highlight vim %}
:%! column -t
{% endhighlight %}

Et voici le résultat:

    1  JavaScript  .js    560,116  891,531  319,537  4,951  1,147  343,483
    2  Ruby        .rb    466,411  469,913  175,577  2,726  607    147,339
    3  Java        .java  388,610  376,683  231,186  4,185  825    161,136
    4  Python      .py    281,835  323,858  130,034  2,538  685    184,908
    5  PHP         .php   275,411  289,899  155,941  2,331  454    150,024

Les colonnes qui m'intéresse sont la 1 (rang), la 2 (langage), la 4
(nombre de dépots) et la dernière (nombre d'issues actives).
Je vais donc sélectionner la 3ème colonne à l'aide de `Ctrl-v` et la
supprimer (avec `d`). Voici ce que donne la sélection d'une colonne en
image si vous n'êtes pas familier de Vim:

{% img /images/vim-column.png %}

Je répète ensuite la sélection/suppression pour les autres colonnes et
j'obtiens:

    1  JavaScript  560,116  343,483
    2  Ruby        466,411  147,339
    3  Java        388,610  161,136
    4  Python      281,835  184,908
    5  PHP         275,411  150,024

Il faut maintenant ajouter une colonne de chiffre qui contiendras le rapport
d'issues par dépots en pourcentage. C'est à dire la 4ème colonne divisée par
la 3ème colonne, le tout multiplié par 100. C'est classiquement un boulot
qu'on confierai au langage Awk, mais j'ai décidé il y a quelques temps de
faire le plus possible de choses avec Ruby, voici donc ce que j'ai écrit
dans Vim:

{% highlight vim %}
:%! ruby -aple '$_ += " \#{(($F[3].to_f/$F[2].to_f)*100).to_i}"'
{% endhighlight %}

Un peu cryptique ? Je l'avoue bien volontiers, mais les one-shots sont
rarement fait pour (peuvent rarement) être lisible… Je ferais certainement
un article sur les switchs a, p, l et e de `ruby`. Quoiqu'il en soit, voici
le résultat:

    1  JavaScript  560,116  343,483 61
    2  Ruby        466,411  147,339 31
    3  Java        388,610  161,136 41
    4  Python      281,835  184,908 65
    5  PHP         275,411  150,024 54

Il reste à trier cette liste sur la 5ème et dernière colonne, un jeu d'enfant
avec l'utilitaire unix `sort`:

{% highlight vim %}
:%! sort -k5nr
{% endhighlight %}

    4  Python      281,835  184,908 65
    1  JavaScript  560,116  343,483 61
    5  PHP         275,411  150,024 54
    3  Java        388,610  161,136 41
    2  Ruby        466,411  147,339 31

Voilà, ça prend un certain temps à décrire mais c'est rapide à faire quand
vous avez sous le coude une paire d'utilitaires qui déchirent !





À demain.



