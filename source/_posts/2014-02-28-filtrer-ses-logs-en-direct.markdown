---
layout: post
title: "Filtrer ses logs en direct"
date: 2014-02-28 20:50
comments: true
categories: [intermédiaire, linux, os x, log, terminal, tail, sed]
---

{% level 2 %}

Aujourd'hui on voit comment filtrer nos fichiers de log en direct à l'aide
des commandes UNIX `tail` et `sed`.

<!-- more -->

Pour afficher un fichier en direct live sur le terminal, autrement dit pour
visualiser au fur et à mesure les ajouts dans ce fichier, on utilise
`tail -f`:

``` bash
tail -f un/fichier/de/log
```

Pour afficher **uniquement** les lignes d'un fichier qui contiennent la
chaîne de caractères `ERROR`, on va utiliser `sed`:

``` bash
sed -n '/ERROR/p' un/fichier/de/log
```

Ou bien pour afficher toutes les lignes d'un fichier **sauf** celles qui
contiennent la chaîne de caractères `bruit`, on utilisera:

``` bash
sed '/bruit/d' un/fichier/de/log
```

Et en combinant les deux, on aura un log en direct et filtré:

``` bash
tail -f un/fichier/de/log | sed -n '/ERROR/p'
```

Et vous, vous utilisez quelle(s) commande(s) ?

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

