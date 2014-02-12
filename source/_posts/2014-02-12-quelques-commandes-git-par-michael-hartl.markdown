---
layout: post
title: "Quelques commandes Git par Michael Hartl"
date: 2014-02-12 20:29
comments: true
categories: [git, ruby, bash, intermédiaire]
---

{% level 2 %}

Michael Hartl, l'auteur de [Ruby on Rails Tutorial](http://ruby.railstutorial.org/)
a écrit plusieurs commandes Git bien utiles.

<!-- more -->

Le code se trouve sur Github : [git-utils](https://github.com/mhartl/git-utils).
On y trouve par exemple une commande `git cleanup`, qui supprime toutes
les branches locales qui ne sont pas encore mergées dans la branche
courante. Ou encore `git merge-branch`, qui merge la branche courante
dans master par défaut.

Aujourd'hui, toutes ces commandes sont écrites en Ruby, mais avant
elle l'était en Bash, comme la suivante:

``` bash
#!/bin/bash git-merge-branch

# Copyright (c) 2013 Michael Hartl
# Released under the MIT License (http://opensource.org/licenses/MIT)

# Merges the current branch into the given branch (defaults to master).
# E.g., 'git merge-branch foobar' merges the current branch into foobar.
# 'git merge-branch', merges the current branch into master.
# git merge-branch uses the --no-ff --log options to ensure that the 
# merge creates a new commit object and that the individual commits appear
# in the log file.
CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
if [ $# -eq 1 ]
then
  TARGET_BRANCH=$1
else
  TARGET_BRANCH="master"
fi
git checkout $TARGET_BRANCH
git merge --no-ff --log $CURRENT_BRANCH
```

Essayez les, certaines pourraient bien vous changer la vie.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
