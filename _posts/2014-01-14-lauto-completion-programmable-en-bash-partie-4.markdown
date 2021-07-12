---
layout: post
title: "L'auto-complétion programmable en bash - partie 4"
date: 2014-01-14 20:54
legacy: true
tags: [bash]
---



Cet article est la suite de:
[L'auto complétion programmable en bash: partie 3](http://lkdjiin.github.io/blog/2014/01/13/lauto-completion-programmable-en-bash-partie-3/).


Un programme bidon pour tester
------------------------------

On va faire un petit jeu de rôle : Vous avez écrit un nouveau langage
informatique revolutionnaire, et maintenant vous voulez lui adjoindre
un outil pour faciliter la gestion des projets. Ce fameux programme, qui
va s'appeller «mytool» aura 3 commandes: `new`, pour créer un projet,
`compile`, pour compiler le projet, et `test`, pour le tester. Et bien sûr,
vous voulez profiter des joies de l'auto complétion:

    mytool c[TAB]

devra devenir:

    mytool compile

<!-- more -->

Pour comprendre les prochains articles, on est pas obligé d'avoir un «vrai»
programme. Mais c'est quand même plus drôle pour faire tout un tas de tests.
Voici donc le magnifique programme `mytool`:

{% highlight bash %}
#!/usr/bin/env bash

case $1 in
  new )
    echo Project created ;;
  test )
    echo Project tested ;;
  compile )
    echo Project compiled ;;
  * )
    echo error ;;
esac
{% endhighlight %}

Assurez vous que le programme ait les droits d'exécution (`chmod +x`)
et qu'il soit dans votre PATH:

    [~]⇒ mytool new
    Project created
    [~]⇒ mytool test
    Project tested
    [~]⇒ mytool compile
    Project compiled
    [~]⇒ mytool
    error

La prochaine, promis, on commencera vraiment à faire de l'auto-complétion.



À demain.




