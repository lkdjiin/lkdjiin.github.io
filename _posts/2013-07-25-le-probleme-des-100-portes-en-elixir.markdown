---
layout: post
title: "Le problème des 100 portes en Elixir"
date: 2013-07-25 07:35
legacy: true
tags: [elixir]
---



Je continue mon périple parmi le [rosetta code](http://rosettacode.org/wiki/)
en m'attaquant au problème des «100 doors».

{% blockquote Rosetta Code http://rosettacode.org/wiki/100_doors 100 doors %}
Problem: You have 100 doors in a row that are all initially closed. You make 100 passes by the doors. The first time through, you visit every door and toggle the door (if the door is closed, you open it; if it is open, you close it). The second time you only visit every 2nd door (door #2, #4, #6, ...). The third time, every 3rd door (door #3, #6, #9, ...), etc, until you only visit the 100th door.

Question: What state are the doors in after the last pass? Which are open, which are closed?
{% endblockquote %}

<!-- more -->

Je me dis que je vais d'abord le faire dans un langage que je connais bien
pour voir de quoi il retourne, et si il n'y a pas de pièges cachés. En
quelques lignes de Ruby, le tour est joué:

{% highlight ruby %}
doors = Array.new(100)

(1..100).each do |interval|
  doors.map!.with_index do |elem, idx|
    (idx+1) % interval == 0 ? !elem : elem
  end
end

# Écrire le numéro des portes ouvertes.
doors.each_with_index {|e, i| puts i+1 if e }
{% endhighlight %}

Voyant cela j'ai pensé que ça allait être assez simple à implémenter en
Elixir. Pas du tout. J'ai galéré longtemps avant de trouver la solution qui
va suivre. Mon plus gros problème avec Elixir est que les variables sont
non-mutables. Une fois définie, une variable ne change pas. Il faut donc
faire appel constament à la récursivité. Je ne nie pas les avantages d'un
tel système (pas d'effets de bords) mais ce n'est pas évident de s'y faire quand
on vient comme moi du monde procédural ou objet. Trêve de baratin, voici
ma solution avec Elixir:

{% highlight elixir %}
defmodule Doors do

  def soluce do
    doors = Enum.map 1..100, fn _ -> false end
    run(doors, 1)
  end

  defp run(doors, interval) when interval > 100 do
    doors
  end

  defp run doors, interval do
    run(switch_doors(doors,interval), interval + 1)
  end

  defp switch_doors(doors, interval) do
    stream = Stream.with_index(doors)
    list = Enum.to_list(stream)
    Enum.map list, fn e ->
      door = elem e, 0
      index = elem(e, 1) + 1
      switch_door rem(index, interval), door
    end
  end

  defp switch_door(0, door), do: not door
  defp switch_door(_, door), do: door
end

soluce = Doors.soluce
Enum.each Enum.to_list(Stream.with_index(soluce)), fn e ->
  if elem(e, 0) == true, do: IO.puts elem(e, 1) + 1
end
{% endhighlight %}

Plutôt long comparé à la version Ruby, hein ? Quoiqu'il en soit, j'en suis
fier, j'ai mis du temps à la pondre, cette version. Je pense que quelqu'un
connaissant bien Elixir doit pouvoir nettement améliorer mon code. Je
vais le poster sur la mailing-list et demander ce qu'il en
pense. Si j'ai des retours (ce dont je ne doute pas) je mettrais la
version améliorée dans un prochain article. En attendant je vais
commenter un peu mon code pour l'expliquer.

{% highlight elixir %}
def soluce do
  doors = Enum.map 1..100, fn _ -> false end
  run(doors, 1)
end
{% endhighlight %}

`soluce` est la seule fonction publique du module. Elle initialise une liste
de 100 éléments avec la valeur `false`. Puis elle commence le travail avec
`run(doors, 1)`, `1` étant le premier intervalle de la série, c'est à dire
qu'on passe par toutes les portes. Une fois la solution découverte, elle est
renvoyée explicitement. Si vous connaissez Ruby, vous savez à quoi je fais
référence, sinon, sachez qu'en Elixir toutes les fonctions renvoie une valeur,
et qu'on a pas besoin de l'indiquer. C'est implicite, la dernière évaluation
est renvoyée. Notez aussi l'usage de `_` qui indique qu'on se fiche du contenu
de la variable.

{% highlight elixir %}
defp run(doors, interval) when interval > 100 do
  doors
end

defp run doors, interval do
  run(switch_doors(doors,interval), interval + 1)
end
{% endhighlight %}

La première version de `run` comporte un *guard*. Elle n'est utilisée que
lorsque `interval` est supérieur à 100. C'est notre clause de sortie de la
fonction récursive.

La seconde version de `run` est utilisée dans tout les autres cas. Elle se
contente de s'appeller elle-même (récursivité) avec une liste des portes
mise à jour et un intervalle incrémenté.

{% highlight elixir %}
defp switch_doors(doors, interval) do
  stream = Stream.with_index(doors)
  list = Enum.to_list(stream)
  Enum.map list, fn e ->
    door = elem e, 0
    index = elem(e, 1) + 1
    switch_door rem(index, interval), door
  end
end
{% endhighlight %}

`switch_doors` est responsable de fabriquer une nouvelle liste de portes.
C'est la fonction qui m'a tenu en échec pendant des heures, jusqu'à ce que
je découvre le module `Stream`. Voyons `switch_doors` en détails:

{% highlight elixir %}
stream = Stream.with_index(doors)
list = Enum.to_list(stream)
{% endhighlight %}

Je crée une nouvelle liste qui va embarquer les valeurs de `doors`
en les associant aux indexs. `list` va ressembler à ça:

    [{false, 0}, {false, 1}, {false, 2}, ... {false, 99}]

Qui en Elixir peut aussi être représenté ainsi:

    [false: 0, false: 1 ...

{% highlight elixir %}
Enum.map list, fn e ->
  door = elem e, 0
  index = elem(e, 1) + 1
  switch_door rem(index, interval), door
end
{% endhighlight %}

`Enum.map` fabrique et renvoie une nouvelle version de la liste des portes.
Chaque élément de `list` (chaque `{false, 0}`) passe à travers une fonction
anonyme qui renvoie false ou true, selon le résultat de index modulo interval.

{% highlight elixir %}
defp switch_door(0, door), do: not door
defp switch_door(_, door), do: door
{% endhighlight %}

Si le modulo égal zéro, on inverse l'état de la porte. Sinon la porte doit
rester dans le même état.

{% highlight elixir %}
Enum.each Enum.to_list(Stream.with_index(soluce)), fn e ->
  if elem(e, 0) == true, do: IO.puts elem(e, 1) + 1
end
{% endhighlight %}

J'écris les numéros des portes ouvertes. Avec mes explications qui précèdent,
j'espère que vous pourrez comprendre comment ça marche.





À demain.


