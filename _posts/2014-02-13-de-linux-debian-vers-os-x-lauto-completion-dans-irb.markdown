---
layout: post
title: "De Linux (Debian) vers OS X - L'auto-complétion dans Irb"
date: 2014-02-13 20:39
legacy: true
tags: [linux, debian, os x, débutant]
---



Aujourd'hui : Comment obtenir l'auto-complétion dans `irb`,
certaines machines OS X (dont la mienne) souffrant de ce bug.

<!-- more -->

Activer l'auto-complétion dans irb
----------------------------------------------------

Si votre `irb` refuse de faire de l'auto-complétion, c'est un bug.
Pour l'activer, vous pouvez utiliser la
[gem Bond](https://github.com/cldwalker/bond) (j'adore ce jeu de
mot, *-si ça en est un ?-*):

{% highlight ruby %}
require 'bond'
Bond.start
{% endhighlight %}

Mieux vaut bien sûr mettre ça directement dans le fichier `.irbrc`,
par exemple:

{% highlight ruby %}
begin
  require 'bond'
  Bond.start
rescue LoadError => err
  warn "Couldn't load bond: #{err}"
end
{% endhighlight %}

[Astuce suivante](/blog/2014/02/14/de-linux-debian-vers-os-x-un-terminal-qui-dechire/)    
[Astuce précédente](/blog/2014/02/06/de-linux-debian-vers-os-x-dossier-parent-dans-lexplorateur/)



À demain.




