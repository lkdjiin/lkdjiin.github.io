---
layout: post
title: "Les fonctions en Julia"
date: 2014-05-11 18:49
legacy: true
tags: [intermédiaire, julia, programmation fonctionnelle]
---



Voici une présentation de base des fonctions en Julia, d'après ce que j'en ai retenu ;)

Tout d'abord, une définition d'une fonction nommée `double`:

{% highlight julia %}
function double(x)
  x + x
end
{% endhighlight %}

<!-- more -->

On voit que la valeur de retour est *implicite*, pas besoin du mot-clé
`return`. On peut le mettre si on veut, la fonction suivante est identique
à la précédente:

{% highlight julia %}
function double(x)
  return x + x
end
{% endhighlight %}

Et voilà comment on appelle cette fonction, rien à dire de particulier
là-dessus:

{% highlight julia %}
double(12) # => 24
{% endhighlight %}

Quand une fonction est aussi simple que la fonction `double`, on peut aussi
la définir comme suit:

{% highlight julia %}
double(x) = x + x
{% endhighlight %}

Si notre programme comporte de nombreuses petites fonctions, cette concision
peut être un atout.

Une fonction Julia est une valeur comme une autre:

{% highlight julia %}
typeof(double) # => Function
{% endhighlight %}

On peut donc affecter cette *valeur* à une autre variable:

{% highlight julia %}
bis = double
bis(3) # => 6
{% endhighlight %}

On peut passer une fonction en argument:

{% highlight julia %}
map(double, [1, 2, 3]) # => [2, 4, 6]
{% endhighlight %}

Un truc sympa en Julia, c'est qu'une fonction est composée de une ou plusieurs
méthodes ! Quand j'ai lu ça la première fois… j'ai pensé que l'auteur de cette
phrase était dingue. En fait il s'agit simplement de fonctions avec un nom
identique mais des signatures différentes. Par exemple, si j'essaye de
*doubler* une chaîne de caractères:

{% highlight julia %}
double("hello")
# => ERROR: no method +(ASCIIString, ASCIIString)
#     in double at none:1
{% endhighlight %}

J'obtiens une erreur car il n'y a pas de fonction `+` pour les *strings*.
Je vais donc ajouter une seconde *méthode* à la fonction `double`, qui
s'occupera du cas particulier des chaînes de caractères:

{% highlight julia %}
double(x::String) = "$x$x"
{% endhighlight %}

Au passage, le caractère `$` permet l'interpolation. Plus intéressant, on voit
que j'ai donné un *type* à l'argument `x`. Quand `double` recevra un argument
de type *String*, c'est cette version (méthode) de la fonction qui sera
utilisée:

{% highlight julia %}
double("hello") # => "hellohello"
{% endhighlight %}

Alors que dans tous les autres cas, ce sera la version (méthode) *générique*
qui sera utilisée:

{% highlight julia %}
double(12)   # => 24
double(0.78) # => 1.56
double(0xf)  # => 0x0000001e
{% endhighlight %}



À demain.



