---
layout: post
title: "Remplacer Sed et Awk par Ruby 6: Séparateur de champ"
date: 2013-12-07 20:54
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

Aujourd'hui on voit comment changer le séparateur de champ à l'aide de
l'option `-F`.

<!-- more -->

Reprenons le fichier de données du [dernier article](http://lkdjiin.github.io/blog/2013/12/05/remplacer-sed-et-awk-par-ruby-5-acceder-aux-champs-slash-colonnes/),
ajoutons un séparateur de champ, par exemple la virgule (`,`) et
*salissons-le* quelque peu:

``` raw data.txt
1, a
2, a
3, b
4 , a
5 ,a
6 ,b
7,b
8,b
9,b
```

Le script du dernier article ne fonctionnera plus, puisque jusqu'ici nous
supposions que les champs étaient séparés par des espaces, ce qui n'est plus
le cas.

En admettant que les champs seront séparés par des virgules, il faut effectuer
un petit changement dans notre script, pour nettoyer le second champ:

``` ruby test.rb
BEGIN { total = 0 }

total += $F[0].to_i if $F[1].strip == "a"

END { puts "Total: #{total}" }
```

Et pour que Ruby sépare bien les champs en tenant compte des virgules, il faut
lui passer l'option `-F`, suivie d'une *regex* (sans les `//`) décrivant
le séparateur:

    [~]⇒ ruby -an -F, test.rb < data.txt 
    Total: 12

Et voilà.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

