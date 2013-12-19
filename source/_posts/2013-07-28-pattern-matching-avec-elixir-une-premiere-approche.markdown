---
layout: post
title: "Pattern matching avec Elixir: une première approche"
date: 2013-07-28 13:32
comments: true
categories: [elixir, débutant, pattern matching]
---

{% level 1 %}

Une tâche réccurente quand on utilise la récursivité pour résoudre un problème
est de séparer une liste en deux parties. La première partie étant le premier
élément de la liste et la seconde partie étant ce qui reste. Pour faire cela,
on peut utiliser le *pattern matching*, qu'on peut traduire par filtrage à
l'aide de motifs.

<!-- more -->

Voyons la syntaxe pour séparer une liste en deux:

``` elixir
[head | tail] = [1, 2, 3]
```

Après ça, `head` (la tête) vaut 1 et `tail` (la queue) vaut [2, 3].
Maintenant les cas exceptionnels: Si on passe une liste d'un seul élément,
`tail` sera une liste vide ([]). Si on passe une liste vide, et bien c'est
une erreur. Voici une capture d'écran qui montre le résultat:

{% img /images/2013-07-28-1.jpg 890 577 pattern matching avec Elixir %}

Pour illustrer le *pattern matching* je vais écrire un module avec une fonction
`minimum` qui doit trouver le plus petit élément dans une liste de nombres
entiers.


``` elixir
defmodule Stats do
  def minimum([head|tail]) do
    minimum tail, head
  end

  defp minimum([], candidate) do
    candidate
  end

  defp minimum([head|tail], candidate) when head < candidate do
    minimum tail, head
  end

  defp minimum([_|tail], candidate) do
    minimum tail, candidate
  end
end
```

On peut l'utiliser comme ceci:

``` elixir
IO.puts Stats.minimum([1, 2, -9, 3])
```

Voici une explication des différentes fonctions:

``` elixir
  def minimum([head|tail]) do
    minimum tail, head
  end
```

Le *pattern matching* s'applique directement dans les arguments de la
fonction. Pour cette première passe, on considère que `head` est à priori
la plus petite valeur de la série.

``` elixir
  defp minimum([], candidate) do
    candidate
  end
```

Là, c'est la clause de sortie de la fonction `minimum`. Si la liste est
vide, c'est qu'on à trouvé la valeur minimum (`candidate`).

``` elixir
  defp minimum([head|tail], candidate) when head < candidate do
    minimum tail, head
  end
```

Quand la liste est encore remplie, on compare la valeur de tête à notre
valeur candidate. Je rappelle que `candidate` est à ce moment la plus petite
valeur trouvée jusqu'ici. Si la valeur de `head` est plus petite que
la valeur de `candidate`, la première remplace la dernière.

``` elixir
  defp minimum([_|tail], candidate) do
    minimum tail, candidate
  end
```

Dans les autres cas, la valeur de tête n'a pas d'intérêt, ce que souligne
le caractère `_` dans `[_|tail]`. On remplace une variable par `_`
lorsque cette variable est inutilisée.

Nouveau venu en programmation fonctionnelle, je pense que je n'entrevois là
que la surface du *pattern matching*.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
