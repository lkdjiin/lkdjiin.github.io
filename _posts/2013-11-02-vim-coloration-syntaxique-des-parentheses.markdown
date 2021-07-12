---
layout: post
title: "Vim: Coloration syntaxique des parenthèses"
date: 2013-11-02 12:04
legacy: true
tags: [vim]
---



Je l'ai annoncé sur ce blog, je suis en train d'apprendre Racket (dérivé de
Scheme, de Lisp). Donc un langage qui fait un très large usage des
parenthèses.

{% img /images/rainbow-parentheses.png %}

<!-- more -->

C'est là que le plugin [Rainbow Parentheses](http://www.vim.org/scripts/script.php?script_id=3772) peut aider.
Il colore les parenthèses différement suivant le niveau d'imbrication.
Il n'est pas activé par défaut, et c'est tant mieux: ce type de coloration
syntaxique n'est pas utile tout le temps, mais seulement à certains moments,
quand on se sent un peu perdu
(*sinon, bonjour l'effet sapin de Noël*). Pour l'activer/le désactiver, il suffit de
taper:

{% highlight vim %}
:RainbowParenthesesToggle
{% endhighlight %}

Si vous l'utilsez régulièrement, il sera sûrement utile de mapper la fonction
précédente. Par exemple pour l'avoir en tapant la touche `leader` puis `p`,
vous ajouterez ceci dans votre .vimrc:

{% highlight vim %}
map <Leader>p :RainbowParenthesesToggle<Enter>
{% endhighlight %}

Le plugin Rainbow Parentheses peut aussi colorer d'autres paires de caractères,
comme `[]`, `{}` et `<>`. Consultez le readme pour en savoir plus.





À demain.



