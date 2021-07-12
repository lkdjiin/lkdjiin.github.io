---
layout: post
title: "Racket pour les rubyists 5: Définitions imbriquées"
date: 2013-11-10 21:17
legacy: true
tags: [racket, ruby]
---



Après avoir vu l'utilisation de la fonction `filter`, on passe aux
définitions de fonctions imbriquées en Racket, ce qui nous permet de
survoler la portée des variables.

<!-- more -->

Fonctions Racket imbriquées
----------------------------
Avec Racket les définitions de fonction peuvent s'imbriquer les unes dans les
autres.  Autrement dit, on peut définir une fonction B à l'intérieur d'une
fonction A. Dans l'exemple suivant, la fonction `bar` est définie à
l'intérieur de la fonction `foo`:

{% highlight racket %}
(define (foo x)
  (define (bar y)
    (+ y 2))
  (bar x))
{% endhighlight %}

Dans le code ci-dessus, `bar` est une fonction qui ajoute 2 à son argument.
La fonction englobante `foo` appelle `bar` et donc son rôle est aussi d'ajouter
2 à son argument, comme on peut le voir dans la session racket suivante:

    -> (foo 10)
    12

Il est important de comprendre que `bar` est définie à l'intérieur de `foo`,
et donc `bar` est *indéfinie* à l'extérieur de `foo`:

    -> (bar 10)
    ; bar: undefined;
    ;  cannot reference undefined identifier

Méthodes Ruby imbriquées
-------------------------
Ruby se comporte différement. Il permet bien de définir une méthode à
l'intérieur d'une autre:

{% highlight irb %}
>> def foo(x)
>>   def bar(y)
>>     y + 2
>>   end
>>   bar x
>> end
nil
>> foo 10
12
{% endhighlight %}

Mais à la différence du comportement de Racket, la méthode Ruby `bar` est
*visible* à l'extérieur de `foo`:

{% highlight irb %}
>> bar 10
12
{% endhighlight %}

Et c'est tout à fait normal. Il s'agit là d'une différence entre fonction
et méthode: une méthode est attachée à un objet.

Retour à Racket
---------------

La méthode `foo` peut être simplifiée. La revoici:

{% highlight racket %}
(define (foo x)
  (define (bar y)
    (+ y 2))
  (bar x))
{% endhighlight %}

Pour la simplifier, il suffit de comprendre que l'argument `x` est *visible*
dans la fonction `bar`:

{% highlight racket %}
(define (foo x)
  (define (bar)
    (+ x 2))
  (bar))
{% endhighlight %}

Évidemment, la vraie simplification serait celle-ci:

{% highlight racket %}
(define (foo x)
  (+ x 2))
{% endhighlight %}

Mais cet article parle de fonctions imbriquées…

La prochaine fois on réunira tout ce qu'on a appris jusqu'ici pour enfin
traduire en Racket la méthode Ruby suivante:

{% highlight ruby %}
def divisors(n)
  (1..n).select {|i| n % i == 0}
end
{% endhighlight %}





À demain.




