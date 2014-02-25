---
layout: post
title: "Sed - Remplacer la n-ième occurence"
date: 2014-02-25 21:10
comments: true
categories: [intermédiaire, unix, sed, texte, éditeur]
---

J'adore Sed. Je l'utilise depuis de longues années. Et pourtant je n'avais
jamais remarqué qu'on pouvait remplacer la n-ième occurence d'un pattern
dans une ligne.

<!-- more -->

Soit le fichier `test` suivant:

    Bonjour le monde !

Pour remplacer le premier `o` par un `-`:

``` bash
sed 's/o/-/' test
```

Pour remplacer tous les `o` par des `-`:

``` bash
sed 's/o/-/g' test
```

Pour remplacer le deuxième `o` par un `-`:

``` bash
sed 's/o/-/2' test
```

Sed, c'est magique !

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


