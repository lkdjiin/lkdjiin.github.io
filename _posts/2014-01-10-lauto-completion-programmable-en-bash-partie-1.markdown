---
layout: post
title: "L'auto complétion programmable en bash: partie 1"
date: 2014-01-10 21:41
legacy: true
tags: [bash, intermédiaire, unix, auto complétion]
---



Ou comment git, apt-get et les autres l'utilisent
--------------------------------------------------

L'auto-complétion de la ligne de commande sur unix, c'est à priori
très simple. Si je tape dans un terminal `ec` suivi de la touche tabulation:

    [~]⇒ ec[TAB]

C'est à dire les deux lettres "ec" suivies de la touche tabulation, la
commande est étendue en :

    echo 

Si il y a plusieurs choix possibles, Bash me les fournis:

    [~]⇒ apti
    aptitude                      aptitude-curses
    aptitude-create-state-bundle  aptitude-run-state-bundle

<!-- more -->

Ça devient plus intéressant quand ça fonctionne aussi avec les *arguments* des
commandes, qu'à priori, le shell ne connait pas. Par exemple :

    [~]⇒ apt-get upg[TAB]

devient :

    apt-get upgrade

Ou encore :

    [~]⇒ git fi[TAB]

qui devient :

    git filter-branch

Et ça devient carrément magique - *en tout cas pour moi* - quand la commande
git réussit l'auto-complétion d'une commande que j'ai ajouté moi-même.  Je
m'explique. J'ai par exemple, dans mon PATH, le fichier bash `git-pom` suivant:

{% highlight bash %}
#!/bin/bash

git push origin master
{% endhighlight %}

Si je tape :

    [~]⇒ git p[TAB]

ça devient :

    pom           pull          push          push-branch   
    [~]⇒  git p

Git, ou bash, ou je ne sais quoi a trouvé la commande `pom` ! Moi ça m'épate
à chaque fois. Notez au passage que le fichier qui contient la nouvelle commande
s'appelle `git-pom` et qu'on peut taper `git pom`. Alors, comment ça
marche ?

Et bien je dois avouer que je n'en sais rien ! J'ai bien une petite idée
des mécanismes en jeu, mais aucunes connaissances sur le sujet. On va
donc découvrir cela ensemble au fil des articles suivants.



À demain.


