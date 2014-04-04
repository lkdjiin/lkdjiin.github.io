---
layout: post
title: "Vim - Un plugin pour markdown - partie 9"
date: 2014-04-04 21:26
comments: true
categories: [vim, débutant, markdown, plugin, vader]
---

{% level 1 %}

Je voudrais maintenant tester que ma fonction pour passer un mot en
italique fonctionne sur le dernier mot de la phrase, lorsque celui-ci
n'a qu'un seul caractère…

<!-- more -->

Voilà le test Vader:

``` raw
Given (a line whose the last word is of length 1):
  abc def ghi j

Execute (starting at the end of the last word who is of length 1):
  execute "normal! fj"
  QuickMarkdownItalic

Expect (last word in italic):
  abc def ghi *j*
```

Et malheureusement, il échoue:

``` raw
    (4/4) [  GIVEN] a line whose the last word is of length 1
    (4/4) [EXECUTE] starting at the end of the last word who is of length 1
    (4/4) [ EXPECT] (X) last word in italic
      - Expected:
          abc def ghi *j*
      - Got:
          abc def ghi j
```

Je m'attendais à un échec, mais pas à celui-ci ! Je pensais obtenir ceci:

    abc def *ghi* j

Donc je trouve ça assez bizarre et j'écris deux autres tests sur le dernier
mot d'une phrase, quand ce mot est d'une longueur correcte:

```
Given (some text):
  abc def ghi jkl mno

Execute (from the beginning of the last word):
  execute "normal! fm"
  QuickMarkdownItalic

Expect (last word in italic):
  abc def ghi jkl *mno*

Execute (from the end of the last word):
  execute "normal! fo"
  QuickMarkdownItalic

Expect (last word in italic):
  abc def ghi jkl *mno*
```

Là encore le test qui débute sur le dernier caractère échoue de la même
manière, c'est à dire sans avoir ajouter aucun `*`.

J'ai déjà entendu dire que Vim pouvait faire des choses bizarres quand
on se trouve à la fin d'une phrase. Je ne sais pas si c'est cela ou la
logique de ma fonction qui est en cause, c'est toujours un mystère et
j'espère avoir le temps ce week-end pour investiguer.

En attendant que je m'y mette, si vous avez des pistes, je suis preneur ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
