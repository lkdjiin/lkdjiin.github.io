---
layout: post
title: "Le hack FizzBuzz en Ruby"
date: 2015-04-30 17:07
comments: true
categories: [ruby, intermédiaire, one liner]
---

{% level 2 %}

Voici ce qui trainait sur le net aujourd'hui, un jeu de
[FizzBuzz](http://en.wikipedia.org/wiki/Fizz_buzz) en une ligne de Ruby:

``` ruby
1.upto(100){|n|puts'FizzBuzz '[o=n**4%-15,o+13]||n}
```

Ce qui donne:

``` bash
ruby -e "1.upto(100){|n|puts'FizzBuzz '[o=n**4%-15,o+13]||n}"
1
2
Fizz
4
Buzz 
Fizz
7
8
Fizz
Buzz 
11
.
.
.
94
Buzz 
Fizz
97
98
Fizz
Buzz 
```

Pour celles et ceux qui ne pigent pas cette ligne de code Ruby, on va la
déconstruire petit à petit.

<!-- more -->

Nous avons affaire à une boucle (j'ai remplacé les `{}` par `do end`):

``` ruby
1.upto(100) do |n|
  puts'FizzBuzz '[o=n**4%-15,o+13]||n
end
```

`a.upto(b)` itère de `a` jusqu'à `b`:

``` irb
$ irb
>> 10.upto(12) do |iteration|
?>   puts iteration
>> end
10
11
12
```

Regardons de plus près l'intérieur de la boucle, là où c'est intéressant.
Ruby permet d'appeler les
méthodes sans utiliser de parenthèses. Ici je les ai simplement rajouter pour
tenter de clarifier le code:

``` ruby
1.upto(100) do |n|
  puts( 'FizzBuzz '[o=n**4%-15,o+13]||n )
end
```

Maintenant qu'on est bien sûr qu'il s'agit de la méthode `puts` avec un
argument bizarre dedans, je sépare les différents éléments de la *grammaire de
Ruby* par des espaces. Toujours pour essayer d'y voir plus clair:

``` ruby
1.upto(100) do |n|
  puts( 'FizzBuzz '[o = n ** 4 % -15, o + 13] || n )
end
```

Arrêtons nous un peu sur les sous-ensembles de chaîne `[a, b]`.
Le premier chiffre est la position de départ, le second est le nombre de
caractères:

``` irb
$ irb
>> "abcdef"[0, 2]
"ab"
>> "abcdef"[3, 2]
"de"
```

Ruby permet de donner une position de départ pas rapport à la fin:

``` irb
>> "abcdef"[-4, 2]
"cd"
```

Pour la suite, notez bien que si on va chercher des caractères **avant** le début ou **après** la fin de la chaîne, on se retrouve avec `nil`. Ça n'est pas une erreur, c'est le comportement attendu:

``` irb
>> "abcdef"[-123, 2]
nil
>> "abcdef"[999, 2]
nil
```

Maintenant essayons de décrypter la formule mathématique.
Utilisons une variable temporaire pour l'isoler:

``` ruby
1.upto(100) do |n|
  o = n ** 4 % -15
  puts( 'FizzBuzz '[o, o + 13] || n )
end
```

En Ruby, `**` est l'opérateur de puissance:

``` irb
$ irb
>> 10 ** 2
100
>> 10 ** 3
1000
>> 10 ** 4
10000
```

Quant à `%`, c'est l'opérateur de la division modulaire, souvent appelé
*modulo*. Si vous avez plein de temps devant vous il y a la page wikipédia sur
[l'arithmétique modulaire](http://fr.wikipedia.org/wiki/Arithm%C3%A9tique_modulaire).
Sinon voici une explication rapide du modulo: **c'est le reste de la division
entière**. Donc `9 % 4 == 1`.

Sauf qu'ici on utilise le modulo avec un nombre négatif. Et là les maths se
compliquent un peu, et surtout différents langages de programmation auront différents
comportements.

Essayons plutôt de *sentir* la formule en l'appliquant aux nombres de 1 à 16:

``` irb
$ irb
>> (1..16).each do |n|
?>   o = n ** 4 % -15
>>   puts "#{n} => #{o}"
>> end
1 => -14
2 => -14
3 => -9
4 => -14
5 => -5
6 => -9
7 => -14
8 => -14
9 => -9
10 => -5
11 => -14
12 => -9
13 => -14
14 => -14
15 => 0
16 => -14
```

J'imagine qu'à ce moment précis, vous êtes plusieurs à crier **«Ha ha !»**.

Cette formule, en Ruby, a donc 4 solutions possibles:

- Quand *n* est un multiple de 3, la solution est **-9**.
- Quand *n* est un multiple de 5, la solution est **-5**.
- Quand *n* est un multiple de 15 (c'est à dire à la fois multiple de 3 et de
  9), la solution est **0**.
- Dans les autres cas, la solution est **-14**.

Voyons ce qu'il se passe avec `'FizzBuzz '` quand `o` vaut respectivement -9, -5, 0 puis -14:

``` irb
$ irb
>> 'FizzBuzz '[-9, -9 + 13]
"Fizz"
>> 'FizzBuzz '[-5, -5 + 13]
"Buzz "
>> 'FizzBuzz '[0, 13]
"FizzBuzz "
>> 'FizzBuzz '[-14, -14 + 13]
nil
```

Peut-être vous demandez vous pourquoi il y a un espace après FizzBuzz ?
En pratique, voici la raison:

``` irb
>> 'FizzBuzz'[-9, -9 + 13]
nil
>> 'FizzBuzz'[-5, -5 + 13]
"zBuzz"
```

En théorie, je vous laisse faire les calculs ;)

Pour finir, il reste à expliquer le `||`, un exemple vaut mieux qu'un long
discours:

``` irb
>> "foo" || 13
"foo"
>> nil || 13
13
```

Voilà, si vous voulez ajouter d'autres explications, les commentaires sont fait
pour ça ;)

{% connexe %}
