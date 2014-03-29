---
layout: post
title: "Vader, un framework de test pour Vim"
date: 2014-03-16 20:52
comments: true
categories: [vim, test, plugin, framework, vader]
---

[Vader](https://github.com/junegunn/vader.vim) est un framework de test pour Vim, écrit en VimScript. Sa syntaxe très simple
fait penser un peu à un mélange de Cucumber et de Python. Il est vraiment sympa
à utiliser.

<!-- more -->

Voici à quoi ressemble un test simple avec Vader:

    Given (A line of text):
      Make a title of this

    Execute (To level 1 title):
      QuickMarkdownTitle1

    Expect (to be a level 1 title):
      Make a title of this
      ====================

Le bloc `Given` permet de remplir un buffer de test avec des données.

Le bloc `Execute` lance des fonctions Vim.

Le bloc `Expect` vérifie que le buffer de test est bien celui attendu
après le passage du bloc `Execute`.

Il existe aussi un bloc `Do`, qui simule le mode normal:

    Given (Some text):
      Make a title of this
      and not of this one

    Do (To title 1):
      gg
      :QuickMarkdownTitle1\<Enter>

    Expect (to be a level 1 title):
      Make a title of this
      ====================
      and not of this one

On lance Vader simplement avec:

``` vim
:Vader
```

et le framework ouvre un nouveau buffer avec toutes les informations
nécessaires:

    Starting Vader: 1 suite(s), 6 case(s)
      Starting Vader: /home/xavier/devel/vim/quickmarkdown/test/titles.vader
        (1/6) [  GIVEN] A line of text
        (1/6) [EXECUTE] To level 1 title
        (1/6) [ EXPECT] to be a level 1 title
        (2/6) [  GIVEN] A line of text
        (2/6) [EXECUTE] To level 2 title
        (2/6) [ EXPECT] to be a level 2 title
        (3/6) [  GIVEN] A line of text
        (3/6) [EXECUTE] To level 3 title
        (3/6) [ EXPECT] to be a level 3 title
        (4/6) [  GIVEN] Some text
        (4/6) [     DO] To title 1
        (4/6) [ EXPECT] to be a level 1 title
        (5/6) [  GIVEN] Some text
        (5/6) [     DO] To title 2
        (5/6) [ EXPECT] to be a level 2 title
        (6/6) [  GIVEN] Some text
        (6/6) [     DO] To title 3
        (6/6) [ EXPECT] to be a level 3 title
      Success/Total: 6/6
    Success/Total: 6/6 (assertions: 0/0)
    Elapsed time: 0.419884 sec.

Vader est «livré» avec coloration syntaxique, ftplugin, plusieurs exemples
d'utilisations. Il peut aussi faire des hooks `before` et `after`, inclure des
fichiers et d'autres choses encore…

Une très bonne découverte, très agréable à utiliser.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


