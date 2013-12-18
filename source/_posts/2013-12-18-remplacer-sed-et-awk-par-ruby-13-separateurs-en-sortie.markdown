---
layout: post
title: "Remplacer Sed et Awk par Ruby 13: Séparateurs en sortie"
date: 2013-12-18 18:58
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

La dernière fois on a vu [les numéros de lignes](http://lkdjiin.github.io/blog/2013/12/17/remplacer-sed-et-awk-par-ruby-12-numero-de-ligne/), aujourd'hui on voit comment
modifier les séparateurs de champ et d'enregistrement.

<!-- more -->

On continue donc avec un exemple trivial, on a ce fichier de données:

``` raw data.txt
1,a
2,b
3,c
```

On va intervertir les champs et modifier le séparateur de champs pour qu'il
devienne un point-virgule (pour le nom des variables prédéfinie, je vous
renvoie à l'article sur [la gem English](http://lkdjiin.github.io/blog/2013/12/14/remplacer-sed-et-awk-par-ruby-11-la-gem-english/)):

``` ruby
BEGIN {
  require 'English'
  $FS = ','
  $OFS = ';'
}
$_ = $F.reverse.join
```

`join` va utiliser automatiquement le contenu de `$OFS`:

``` bash
[~]⇒ ruby -apl test1.rb data.txt
a;1
b;2
c;3
```

Parfois on veut aussi modifier le séparateur d'enregistrements (les enregistrements
sont ici nos lignes du fichier). Par exemple, pour passer du caractère *newline* à
`:`:

``` ruby
BEGIN {
  require 'English'
  $FS = ','
  $OFS = ';'
  $ORS = ':'
}
$_ = $F.reverse.join
```

Et le résultat:

``` bash
[~]⇒ ruby -apl test1.rb data.txt
a;1:b;2:c;3:
```

Et bien sûr, si vous le voulez vraiment, vous pouvez toujours écrire ce
script en une ligne, directement dans la console:

``` bash
[~]⇒ ruby -aple 'BEGIN{$;=",";$,=";";$\=":"};$_=$F.reverse.join' data.txt
```

Mais êtes-vous sûr de vouloir faire ça ?!

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
