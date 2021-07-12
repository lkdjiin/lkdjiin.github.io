---
layout: post
title: "Un plugin Vim pour replier/folder les commentaires"
date: 2013-12-02 18:27
legacy: true
tags: [vim, annonce]
---

Dans un [article précédent](http://lkdjiin.github.io/blog/2013/11/28/vim-plier-folder-les-commentaires-de-style-unix/), je montrai comment écrire une fonction pour
folder les commentaires de style Unix dans un fichier. Cette solution avait
plusieurs limites alors j'ai eu envie d'en faire un plugin plus
intéressant. Je vous présente donc vim-foldcomments, mon premier plugin
pour Vim.

<!-- more -->

Pouvoir folder/replier tous les commentaires d'un fichier peut être
utile quand vous étudiez un tout nouveau code, ou au contraire, quand vous
travaillez sur un code bien connu.
Vous pouvez trouver le plugin sur Github: [vim-foldcomments](https://github.com/lkdjiin/vim-foldcomments).
Une fois installé, avec [Pathogen](https://github.com/tpope/vim-pathogen) par exemple,
vous pouvez taper la commande:

    :FoldComments

pour replier les commentaires du fichier. Personnelement j'ai mappé cette
commande sur la touche F5 en mettant ceci dans mon .vimrc:

{% highlight vim %}
map<F5> FoldComments<Enter>
{% endhighlight %}

Le plugin est en version béta et ne gère pour l'instant que quelques
langages: Ruby, Haskell, Java, C, Javascript, Logo, Racket, Scheme, Vim,
ainsi que tous commentaires de style Unix (`#`). Les commentaires
multilignes (`/* … */` en C ou encore `=begin … =end` en Ruby) sont aussi
pris en compte.

N'hésitez pas à le tester et à me donner votre opinion. Vous pouvez aussi
bien sûr participer au code sur Github.





À demain.


