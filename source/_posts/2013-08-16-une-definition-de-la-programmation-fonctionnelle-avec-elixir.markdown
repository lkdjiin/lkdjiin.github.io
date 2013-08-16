---
layout: post
title: "Une définition de la programmation fonctionnelle avec Elixir"
date: 2013-08-16 09:17
comments: true
categories: [elixir, programmation fonctionnelle, intermédiaire]
---

{% level 2 %}

Ou ma tentative désespérée de comprendre la non mutabilité
---------------------------------------------------------------
Cet article est un article égoiste ! Depuis que je joue un peu avec Elixir, je
m'aperçois que j'ai des soucis à comprendre *vraiment* la programmation
fonctionnelle.
J'ai entre autres, des difficultés à me faire au coté immuable, non-mutable,
de la chose (*immutable* en anglais). Je tente donc aujourd'hui de
mettre au clair mes idées sur la question. Ce qui suit peut ressembler
à un dialogue de fou, vous êtes prévenus.

<!-- more -->

Revoici le module Somme, que j'ai utilisé dans un [précédent article](http://lkdjiin.github.io/blog/2013/07/24/elixir-calculer-la-somme-des-n-premiers-entiers-suite-et-fin/).

``` elixir somme.exs
defmodule Somme do
  def run(0, acc), do: acc
  def run(n, acc), do: run(n - 1, n + acc)
end
IO.puts Somme.run(5, 0)
```

Je vais l'écrire dans un bon vieux langage procédural, et analyser ce qu'il
s'y passe.

``` c somme.c
#include<stdio.h>

int main(void)
{
    int somme = 0;
    for(int n = 5 ; n > 0 ; n--) {
        somme += n;
    } 
    printf("%i\n", somme);
    return 0;
}
```

On compile et on lance:

    $ gcc somme.c -std=c99
    $ ./a.out 
    15

Ici pas de récursivité mais une simple itération. Une boucle qui change la
variable `somme` à chaque passage. Je crois qu'on devrait d'abord définir
ce qu'est une variable. Une variable, c'est un concept. Une variable définit
à la fois un contenant, un contenu et un type, tout cela accessible par un
nom. Notre variable a ici pour nom `somme`. Son type est `int`. Son contenu,
ou encore sa valeur est initialement 0 et change à chaque itération. Son
contenant est un emplacement en mémoire, qui lui ne change pas. «*Et tu sais ça
comment que ça change pas ?*» Bon, puisque j'ai besoin d'une preuve,
j'ajoute un traceur qui affiche l'emplacement mémoire de `somme`:

``` c
#include<stdio.h>

int main(void)
{
    int somme = 0;
    printf("%d\n", &somme);
    for(int n = 5 ; n > 0 ; n--) {
        somme += n;
        printf("%d\n", &somme);
    } 
    printf("%i\n", somme);
    return 0;
}
```

    $ gcc somme.c -std=c99
    $ ./a.out 
    -1081032008
    -1081032008
    -1081032008
    -1081032008
    -1081032008
    -1081032008
    15

Voilà, on le sait maintenant: la *valeur* de `somme` change, mais son
*emplacement* (son contenant) reste identique.

Si je tente maintenant de mimer ce comportement avec Elixir, je serais tenté
d'écrire:

``` elixir
somme = 0
Enum.each 5..1, fn n ->
  somme = somme + n
end
IO.puts somme
```

    $ elixir somme.exs 
    /home/xavier/somme.exs:3: variable somme is unused
    0

Comme Elixir est sympa, il tente de me prévenir que quelque chose ne
tourne pas rond. On peut penser à un problème de *scope*, se dire que le
`somme` à l'intérieur de la fonction anonyme n'est pas le même que le
`somme` à l'extérieur de cette fonction. Mais c'est pas ça. Ou 
plus exactement ce n'est pas *seulement* ça:

``` elixir
somme = 100
Enum.each 5..1, fn n ->
  somme = somme + n
  IO.puts somme
end
IO.puts somme
```

    $ elixir somme.exs 
    105
    104
    103
    102
    101
    100

La valeur du `somme` de l'intérieur est initialisée à chaque
itération par la valeur du `somme` de l'extérieur.
Donc le `somme` extérieur est connu dans la fonction anonyme.
Ce comportement me
fais m'arracher les cheveux, je sens que je passe complètement à coté
d'un truc essentiel. Je sais qu'on n'écrirait pas cette fonction de
cette manière, mais je veux comprendre *pourquoi* ce comportement 
quand je fais ça. En fait donner le même nom à ces deux variables est
une illusion.
Pour Elixir le contenu de `somme` est immuable, il ne peut pas changer.
Il serait donc plus juste d'écrire ça:

``` elixir
somme = 0
Enum.each 5..1, fn n ->
  temp = somme + n
end
IO.puts somme
```

Ce qui, évidemment, ne mène à rien. Je commence peut-être à comprendre. 
Si je reprend le programme du départ:

``` elixir somme.exs
defmodule Somme do
  def run(0, acc), do: acc
  def run(n, acc), do: run(n - 1, n + acc)
end
IO.puts Somme.run(5, 0)
```

On voit bien que les variables ne changent (ne mutent) jamais. Ce sont à
chaque fois de *nouvelle création* qui sont passées dans les paramètres.

``` elixir
def run(n, acc), do: run(n - 1, n + acc)
```

Lors d'un passage précis dans cette fonction, on se fiche royalement de savoir
quel était l'état de `n` et de `acc` lors des passages précédents. Ce qui
n'est pas le cas dans l'exemple en C:

``` c
for(int n = 5 ; n > 0 ; n--) {
    somme += n;
} 
```

À chaque passage dans la boucle, il faut connaître l'état de `somme` dans
l'itération précédente.

On m'avait pourtant bien dit que la programmation fonctionnelle s'occupait
des *transformations* et pas des *états*. Mais je ne voyais pas du tout
ce que ça pouvait bien signifier. C'est maintenant un peu plus clair,
même s'il me reste encore du chemin à parcourir pour bien saisir tout
ce qu'implique la programmation fonctionnelle…

À demain.

