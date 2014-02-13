---
layout: post
title: "De Linux (Debian) vers OS X - L'auto-complétion dans Irb"
date: 2014-02-13 20:39
comments: true
categories: [linux, debian, os x, débutant]
---

{% level 1 %}

Aujourd'hui : Comment obtenir l'auto-complétion dans `irb`,
certaines machines OS X (dont la mienne) souffrant de ce bug.

<!-- more -->

Activer l'auto-complétion dans irb
----------------------------------------------------

Si votre `irb` refuse de faire de l'auto-complétion, c'est un bug.
Pour l'activer, vous pouvez utiliser la
[gem Bond](https://github.com/cldwalker/bond) (j'adore ce jeu de
mot, *-si ça en est un ?-*):

``` ruby
require 'bond'
Bond.start
```

Mieux vaut bien sûr mettre ça directement dans le fichier `.irbrc`,
par exemple:

``` ruby .irbrc
begin
  require 'bond'
  Bond.start
rescue LoadError => err
  warn "Couldn't load bond: #{err}"
end
```

[Astuce précédente](/blog/2014/02/06/de-linux-debian-vers-os-x-dossier-parent-dans-lexplorateur/)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


