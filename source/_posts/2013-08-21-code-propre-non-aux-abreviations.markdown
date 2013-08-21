---
layout: post
title: "Code propre: Non aux abréviations"
date: 2013-08-21 14:46
comments: true
categories: [refactoring, ruby]
---

{% level 1 %}

Pour l'écriture du 
[langage Naam](http://lkdjiin.github.io/blog/2013/08/01/implementer-un-langage-sur-la-machine-virtuelle-parrot-partie-1/),
je cherchais une implémentation toute
prête de l'algorithme 
[Shunting Yard](http://en.wikipedia.org/wiki/Shunting_yard_algorithm)
en Ruby. Je suis tombé sur
[cet article](http://www.hokstad.com/operator-precedence-parser)
qui a retenu mon attention car l'auteur propose en plus
la sortie dans un arbre syntaxique. Ce qui est exactement ce que je voulais.
Par contre le code est une horreur à lire. Ça m'a donné l'idée d'une série
d'articles sur le refactoring (et ce que je pense être un code propre), 
à partir d'exemples réels.

<!-- more -->

Une abréviation ne veut pas forcement dire ce que vous pensez
-------------------------------------------------------------
Du moins 99 fois sur 100 une abréviation est ambigue. Voyez le code suivant:

``` ruby
Oper = Struct.new(:pri,:sym,:type)
```

Une seule ligne de code et trois abréviations (même quatre en comptant le
`Struct`, mais là dessus je n'ai pas la main). Que peut bien vouloir dire
`Oper` ? Operator, Operand, Operation ? Et que veut dire `pri` ? Primary,
priority, private ? Et pour `sym`, est-ce symbol ou symlink ou autre chose ?

Comparez avec la version suivante:

``` ruby
Operator = Struct.new(:priority, :symbol, :type)
```

Laquelle vous semble la plus lisible ?  De prime abord on peut penser qu'il est
simple de déduire la signification d'un nom grâce au contexte. Mais je suis
persuadé du contraire.

D'abord, penser au contexte demande au lecteur de fournir un effort
intellectuel. Et cette énergie serait mieux utilisée à résoudre un
problème, à étendre le code, plutôt qu'à le décrypter. 
Un code est souvent assez complexe par lui-même, pourquoi
demander un effort supplémentaire inutile au lecteur ?

Ensuite ça n'est pas seulement une question de contexte, mais aussi
de personne. Pour untel, oper est clairement l'abréviation d'operand, alors
que pour tel autre c'est clairement l'abréviation d'operator. Tout dépend
du vécu de la personne en question. Pourquoi mettre de l'ambiguité dans
nos codes ?

Voici un autre exemple:

``` ruby
o = @ostack.pop
if o.type == :lp
  @ostack << o if pri > 0
  return
end
@out.oper(o)
```

Qu'est-ce que `o`, `lp`, `ostack` ? Imaginez le temps que prendra
la compréhension d'une trentaine de lignes comme celles-ci. Et maintenant
comparez avec ce qui suit:

``` ruby
an_operator = @operators.pop
if an_operator.type == :left_parenthesis
  @operators << an_operator if priority > 0
  return
end
@output.operator(an_operator)
```

C'est plus verbeux, mais même si vous ne connaissez pas Ruby, une simple
lecture suffit pour comprendre ce que fait le code. Remarquez que j'ai
seulement supprimé les abréviations, il y aurait d'autres choses à dire
sur le refactoring de ce code mais ce sera pour un autre article.

J'espère avoir convaincu les sceptiques.
Pour finir je dois faire mon meaculpa: je me rends compte que j'utilise
bien trop d'abréviations dans mon code. À partir d'aujourd'hui, j'arrête ;)

À demain.

