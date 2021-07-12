---
layout: post
title: "Remplacer Sed et Awk par Ruby 13: Séparateurs en sortie"
date: 2013-12-18 18:58
legacy: true
tags: [sed, awk, ruby, débutant]
---



La dernière fois on a vu [les numéros de lignes](http://lkdjiin.github.io/blog/2013/12/17/remplacer-sed-et-awk-par-ruby-12-numero-de-ligne/), aujourd'hui on voit comment
modifier les séparateurs de champ et d'enregistrement.

<!-- more -->

On continue donc avec un exemple trivial, on a ce fichier de données:

{% highlight raw %}
1,a
2,b
3,c
{% endhighlight %}

On va intervertir les champs et modifier le séparateur de champs pour qu'il
devienne un point-virgule (pour le nom des variables prédéfinie, je vous
renvoie à l'article sur [la gem English](http://lkdjiin.github.io/blog/2013/12/14/remplacer-sed-et-awk-par-ruby-11-la-gem-english/)):

{% highlight ruby %}
BEGIN {
  require 'English'
  $FS = ','
  $OFS = ';'
}
$_ = $F.reverse.join
{% endhighlight %}

`join` va utiliser automatiquement le contenu de `$OFS`:

{% highlight bash %}
[~]⇒ ruby -apl test1.rb data.txt
a;1
b;2
c;3
{% endhighlight %}

Parfois on veut aussi modifier le séparateur d'enregistrements (les enregistrements
sont ici nos lignes du fichier). Par exemple, pour passer du caractère *newline* à
`:`:

{% highlight ruby %}
BEGIN {
  require 'English'
  $FS = ','
  $OFS = ';'
  $ORS = ':'
}
$_ = $F.reverse.join
{% endhighlight %}

Et le résultat:

{% highlight bash %}
[~]⇒ ruby -apl test1.rb data.txt
a;1:b;2:c;3:
{% endhighlight %}

Et bien sûr, si vous le voulez vraiment, vous pouvez toujours écrire ce
script en une ligne, directement dans la console:

{% highlight bash %}
[~]⇒ ruby -aple 'BEGIN{$;=",";$,=";";$\=":"};$_=$F.reverse.join' data.txt
{% endhighlight %}

Mais êtes-vous sûr de vouloir faire ça ?!





À demain.


