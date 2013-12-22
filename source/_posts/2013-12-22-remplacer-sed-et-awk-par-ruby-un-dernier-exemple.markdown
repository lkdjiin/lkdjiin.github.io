---
layout: post
title: "Remplacer Sed et Awk par Ruby: Un dernier exemple"
date: 2013-12-22 20:58
comments: true
categories: [sed, awk, ruby, débutant, bash]
---

{% level 1 %}

Avant de mettre un terme à cette série d'articles, j'aimerais donner
un dernier exemple concret de l'utilisation de Ruby en *mode* Sed/Awk.
Il y a quelques jours, j'ai ajouté un bouton «flattr» à la fin des
quelques 160 articles de ce blog. Voici comment j'ai fait…

<!-- more -->

Tout d'abord le script Ruby:

``` ruby script.rb
BEGIN{code= "code à insérer"}

if $_.start_with?("À demain.")
  $_ = "\n\n#{code}\n\n#{$_}"
end
```

Je cherche à insérer le code avant la chaîne "À demain.", qui termine
chacun de mes articles. Si vous avez suivi cette série d'articles depuis
le début, j'espère que ce script parle de lui-même…
Notez quand même que ce script demande une version de Ruby supérieure
ou égale à 2.0, ou alors il faudra ajouter un commentaire *magique* pour
spécifier l'encodage utf-8.

Maintenant, comment appliquer ce script à chacun des articles. J'ai choisi
d'utiliser une boucle en Bash:

``` bash
[~]⇒ for i in *.markdown; do ruby -p -i script.rb $i; done
```

Si vous avez besoin d'explications sur cette ligne de commande, je vous
renvoie à ces articles:

- [ruby -p](http://lkdjiin.github.io/blog/2013/12/04/remplacer-sed-et-awk-par-ruby-4-les-options-p-et-l/)
- [ruby -i](http://lkdjiin.github.io/blog/2013/12/08/remplacer-sed-et-awk-par-ruby-7-modifier-slash-sauvegarder-les-donnees/)
- [Les boucles en Bash](http://lkdjiin.github.io/blog/2013/08/23/bash-ajouter-une-ligne-a-la-fin-de-plusieurs-fichiers/)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

