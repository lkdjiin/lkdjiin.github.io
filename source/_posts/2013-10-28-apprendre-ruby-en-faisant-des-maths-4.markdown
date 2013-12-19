---
layout: post
title: "Apprendre Ruby en faisant des maths 4"
date: 2013-10-28 16:15
comments: true
categories: [ruby, débutant, tutoriel]
---

{% level 1 %}

La [dernière fois](http://lkdjiin.github.io/blog/2013/10/25/apprendre-ruby-en-faisant-des-maths-3/),
on a écrit une méthode qui calcule et renvoie les diviseurs d'un nombre n:

``` ruby
def divisors(n)
  (1..n).select {|int| n % int == 0 }
end
```

Aujourd'hui, on se sert de cette méthode pour en écrire une autre.

<!-- more -->

Après avoir obtenu la liste des diviseurs d'un nombre, je voudrais maintenant
pouvoir obtenir la liste des diviseurs *stricts* d'un nombre. C'est à dire
tous les diviseurs de n *sauf* le nombre n lui-même.

    diviseurs de 8 :         1 ; 2 ; 4 ; 8
    diviseurs stricts de 8 : 1 ; 2 ; 4

La méthode `divisors` fait *presque* ce qu'on veut. Elle renvoie un nombre de
trop, le dernier. On voudrait donc une nouvelle méthode qui renvoie la même
chose que `divisors`, exepté le dernier élément de la liste. Voyons comment
obtenir juste une partie d'une liste à l'aide d'`irb`:

``` irb
>> def divisors(n)
>>   (1..n).select {|int| n % int == 0 }
>> end
>> liste = divisors 8
=> [1, 2, 4, 8]
```

On a commencé par reécrire la méthode `divisors`, puis on a assigné à la
variable *liste* les diviseurs du nombre 8. Notre liste (qui, je le rappelle
est de type `Array`) comporte quatre éléments. En Ruby, comme dans beaucoup
d'autres langages, le numéro d'ordre d'un élément d'une liste (qu'on appelle
aussi indice ou index) comme avec zéro. Notre liste à donc 4 éléments, dont
les indexs vont de 0 à 3:

    index  élément
      0       1
      1       2
      2       4
      3       8

Pour obtenir le 1er élément (index 0) je dois écrire:

``` irb
>> liste[0]
=> 1
```

Pour obtenir le 4ème, et dernier, élément (index 3) j'écris:

``` irb
>> liste[3]
=> 8
```

C'est bien joli mais je veux obtenir un *ensemble* d'élément, et pas un
élément unique comme dans les exemples précédents. Et si on essayait avec
un `Range` ? On veut les 3 premiers éléments, autrement dit les éléments
d'index 0 à 2:

``` irb
>> liste[0..2]
=> [1, 2, 4]
```

On y est presque ! Effectivement, ce que je veux en réalité ce n'est pas
les éléments de 0 jusqu'à 2, mais les éléments de 0 jusqu'à *l'avant-dernier*.
Je veux que ça fonctionne quelque soit le nombre d'élément de la liste.
Pour cela, Ruby offre une syntaxe très simple: le dernier élément de la
liste se voit attribuer l'index `-1`:

``` irb
>> liste[0..-1]
=> [1, 2, 4, 8]
```

Et comme vous l'avez peut-être déjà deviné, l'avant-dernier élément possède
l'index `-2` (et ainsi de suite…):

``` irb
>> liste[0..-2]
=> [1, 2, 4]
```

Cette fois ça y est, on est prêt à se servir de la méthode `divisors` comme
d'une base pour construire une nouvelle méthode. Celle-ci va s'appeler
`proper_divisors`, ce qui signifie «diviseurs stricts» en anglais:

``` irb
>> def proper_divisors(n)
>>   divisors(n)[0..-2]
>> end
>> divisors 8
=> [1, 2, 4, 8]
>> proper_divisors 8
=> [1, 2, 4]
```



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

