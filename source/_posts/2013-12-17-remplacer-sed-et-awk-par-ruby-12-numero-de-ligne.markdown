---
layout: post
title: "Remplacer Sed et Awk par Ruby 12: Numéro de ligne"
date: 2013-12-17 21:52
comments: true
categories: [sed, awk, ruby, débutant]
---

Après avoir vu l'utilité de [la gem English](http://lkdjiin.github.io/blog/2013/12/14/remplacer-sed-et-awk-par-ruby-11-la-gem-english/), on voit aujourd'hui une utilisation
des numéros de ligne pour créer un échantillon de données.

<!-- more -->

La variable prédéfinie `$.` contient le numéro de la ligne en cours de
traitement. Une utilisation de cette variable, que j'aime beaucoup, est
la création d'un petit échantillon (*sample*) de données, à partir d'un
long fichier.

Pour la démonstration, prenons un fichier de données de 33 lignes:

``` raw data.txt
1
2
3
.
.
.
33
```

L'idée est de ne prendre qu'une ligne sur dix. Voilà le script:

``` ruby test.rb
puts $_ if $. % 10 == 0
```

Ou, en utilisant la gem English:

``` ruby test1.rb
BEGIN { require 'English' }
puts $LAST_READ_LINE if $INPUT_LINE_NUMBER % 10 == 0
```

La ligne en cours est affichée seulement quand le numéro de la ligne est
un multiple de 10:

``` bash
[~]⇒ ruby -n test.rb data.txt
10
20
30
```

Intéressant quand on veut se créer rapidement un petit jeu de données pour
tester quelque chose…



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
