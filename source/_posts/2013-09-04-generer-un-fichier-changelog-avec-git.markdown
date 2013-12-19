---
layout: post
title: "Générer un fichier Changelog avec Git"
date: 2013-09-04 11:23
comments: true
categories: [débutant, git, ruby, script]
---

{% level 1 %}

*J'ai écrit un script pour Git qui permet de produire un fichier*
changelog
*en html ou en markdown à partir des commits.*

<!-- more -->

Dans un
[article précédent](http://lkdjiin.github.io/blog/2013/07/18/comment-etendre-git-avec-ses-propres-scripts-la-suite/)
j'ai montré comment étendre Git avec un script pour créer ses propres
commandes. Aujourd'hui je vous présente mon script `git-changelog`.
Vous pouvez le trouver sur
[Github](https://github.com/lkdjiin/git-changelog).

Il s'agit d'un script Ruby qui ajoute une commande `changelog` à Git.
Il est utile pour automatiser (ou semi-automatiser) la production du
fichier changelog. Il peut produire des fichiers au format HTML ou au
format Markdown.

Pour l'installer, il faut mettre le fichier `git-changelog` quelque part
dans votre PATH, après l'avoir téléchargé.

Utilisation
----------
Sortie sur la console:

    git changelog

Sortie dans un fichier:

    git changelog > changelog.markdown

Le script accepte l'option `--since`. C'est la même option qu'utilise la
commande `git log`:

    git changelog --since=2013-07-01
    git changelog --since=10.days

Sortie au format HTML:

    git changelog --html

Un exemple de combinaison:

    git changelog --html --since=2013-05-27 > changelog.html

Un exemple
----------

Voici ce que produit `git-changelog`:

    2013-07-18 Version 0.2.1  
    ==========================
    * 2013-07-18 Fix bug for markdown format  
      Html entities are now escaped.
    * 2013-07-18 Fix bug with markdown format  
      Commit body now start on a new line.
    * 2013-07-18 Add auto-generated changelog file  

    2013-07-18 Version 0.2.0  
    ==========================
    * 2013-07-18 Add html format output  
      A new --html option outputs a &lt;ul&gt;.
    * 2013-07-17 First commit  
      The script outputs in markdown and accept the option '--since'.

Et voilà ce que ça donne (avec le style de ce blog):

2013-07-18 Version 0.2.1  
==========================
* 2013-07-18 Fix bug for markdown format  
  Html entities are now escaped.
* 2013-07-18 Fix bug with markdown format  
  Commit body now start on a new line.
* 2013-07-18 Add auto-generated changelog file  

2013-07-18 Version 0.2.0  
==========================
* 2013-07-18 Add html format output  
  A new --html option outputs a &lt;ul&gt;.
* 2013-07-17 First commit  
  The script outputs in markdown and accept the option '--since'.

Rake task
---------

Voici un exemple de *rake task* pour une gem Ruby:

``` ruby
desc "Generate the changelog"
task :changelog do
  system "git changelog > Changelog.markdown"
end
```

Et un exemple pour un projet Rails:

``` ruby lib/tasks/changelog.rake
desc "Generate the changelog in html"
task :changelog do
  system "git changelog --html > app/views/pages/_changelog.html"
end
```



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
