---
layout: post
title: "Une regex pour savoir si un nombre est premier"
date: 2013-11-05 16:55
legacy: true
tags: [regex, ruby]
---



Aujourd'hui je traduis (approximativement) un article de 2007 qui m'a fasciné:
[A regular expression to check for prime numbers](http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/).

<!-- more -->

Les regexs sont très puissantes. C'est un truc que je lis une ou deux fois par
jour sur le web.

Pendant que j'étais sur le net aujourd'hui, je suis tombé sur
[cette page](http://montreal.pm.org/tech/neil_kandalgaonkar.shtml)
qui décrit minutieusement la regex `/^1?$|^(11+?)\1+$/` en Perl pour voir
si un nombre est premier ou non !

Pour être franc, j'étais sceptique. La regex semble être magique ! Et je 
voulais la comprendre mieux. Je l'ai réécrite en Ruby, pour la tester:

{% highlight irb %}
[~]⇒ irb
>> def prime?(n)
>>   ("1" * n) !~ /^1?$|^(11+?)\1+$/
>> end
=>
>> prime? 10
=> false
>> prime? 11
=> true
>> prime? 12
=> false
>> prime? 13
=> true
>> prime? 99
=> false
>> prime? 100
=> false
>> prime? 101
=> true
{% endhighlight %}

Cool ! Ça marche aussi en Ruby ! Ce qui veut dire qu'il n'y a aucune magie
due à Perl. La regex fonctionne vraiment. Mais comment ? Essayons de la
décortiquer.

Est-ce-que 7 est un nombre premier ?
------------------------------------

Pour le savoir, la méthode génère "1111111" et regarde si cette chaîne
**ne correspond pas** avec `/^1?$|^(11+?)\1+$/`. Si il n'y a pas
correspondance, alors le nombre est premier.

Notez que la regex a deux parties (séparées par une barre verticale `|`).

La première partie `/^1?$/` est triviale, et cherche une correspondance
avec un début de ligne (`^`), un 1 optionel (`1?`) et une fin de ligne
(`$`), ce qui implique une chaîne vide ou "1". Donc l'appel de cette
méthode quand n vaut 0 ou 1 renverra false, le bon résultat.

La seconde partie est plus… magique…

`/^(11+?)\1+$/` cherche une correspondance avec un début de ligne (`^`)
puis `11+?` puis `\1+` et finalement une fin de ligne (`$`).
Je suppose que vous savez que `\1` est une variable attachée à ce qui a été
mis en correspondance précédement (dans notre cas avec `11+?`).

Allons y lentement…

`(11+?)` fait deux choses:

1. Il cherche une correspondance avec un "1" suivi par un ou plusieurs autres
   "1" **de façon minimale**. Ce qui signifie qu'on aura une correspondance
   avec "11" la première fois (notez que si il n'y avait pas de `?` dans
   `(11+?)` c'est la chaîne entière qui serait mise en correspondance).
2. La chaîne obtenue ("11" la première fois) est attachée à la variable `\1`.

`\1+` cherche alors une correspondance avec ce qu'on a obtenu avant ("11"
la première fois) **de manière répétitive, une ou plusieurs fois**.
Si une correspondance est trouvée, alors le nombre n'est pas premier.

Si vous suivez jusqu'ici, vous avez peut-être réalisé que cela éliminait tout
les nombres pairs, excepté 2 (par exemple, 8 est "11111111" and donc `(11+?)`
va correspondre avec "11" et `\1+` va correspondre avec "111111").

Pour les nombres impairs (7 dans notre cas), le `(11+?)` correspond à "11"
la première fois mais `\1+$` ne peut pas être vrai (notez le `$`) puisqu'il
reste cinq "1". Le moteur de regexp va **revenir en arrière** et `(11+?)`
va alors correspondre avec "111" et là aussi, `\1+$` sera faux puisqu'il
reste quatre "1" (et à ce moment là, `\1+$` ne peut correspondre qu'avec un
nombre de "1" qui est multiple de 3, suivi par une fin de ligne), etc…
D'où le fait que "1111111" ne correspondra jamais avec la regex, ce qui
implique que 7 est un nombre premier.

[...] Voyons ce qu'il se passe avec 9, qui n'est pas un nombre premier:
"1" * 9 devrait correspondre avec la regex.

"1" * 9 = "111111111". `(11+?)` correspond initialement à "11". `\1+$` ne
peut être mis en correspondance puisqu'il reste 7 "1". Quand le moteur de
regex repart en arrière, `(11+?)` correspond alors avec "111". Et cette
fois `\1+$` correspond aux 6 "1" restants ! D'où 9 n'est pas premier.

Simple et beau en même temps.





À demain.



