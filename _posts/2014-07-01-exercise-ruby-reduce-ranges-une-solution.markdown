---
layout: post
title: "Exercise Ruby : Reduce ranges - une solution"
date: 2014-07-01 21:07
legacy: true
tags: [ruby, intermédiaire]
---



Je rappelle le sujet/énoncé : en partant de ce tableau:

    [1, 2, 3, 7, 9, 17, 18, 19, 20]

on doit obtenir celui-ci:

    [1..3, 7, 9, 17..20]

En y réflechissant un peu, je me suis demandé si le module `Enumerable`
offrait une méthode qui nous aiderait. Bingo ! J'ai trouvé la méthode
`slice_before`, que je n'avais jamais utilisé jusqu'ici. Voici donc ma
solution:

<!-- more -->

{% highlight ruby %}
def range_reduce(array)
  previous = array.first
  array.slice_before do |element|
    previous, previous2 = element, previous
    previous2.succ != element
  end.map do |element|
    element.size == 1 ? element.first : element.first..element.last
  end
end
{% endhighlight %}

Quand je la compare à la solution originale de l'auteur de la gem:

{% highlight ruby %}
def original(array)
  arr = array.dup
  arr.each_with_index do |el, index|
    range_index = index + 1
    prev = el
    while arr[range_index] == prev + 1 do
      prev = arr[range_index]
      range_index += 1
    end
    arr[index..range_index-1] = (arr[index]..arr[range_index-1]) unless index == range_index - 1
  end
end
{% endhighlight %}

Je me dis que je préfère la mienne, que je la trouve plus claire. Et j'étais
à deux doigts de balancer ma belle solution dans une *Pull Request* à l'auteur,
quand je me suis dis que je ferais bien de faire un benchmark quand même.
Et là, *patatra*:

{% highlight ruby %}
require 'benchmark'

array1 = [1, 2, 3, 7, 9, 17, 18, 19, 20]

Benchmark.bmbm do |x|
  x.report("mine") { 100_000.times { range_reduce(array1) } }
  x.report("original") { 100_000.times { original(array1) } }
end
{% endhighlight %}

    Rehearsal --------------------------------------------
    mine       2.270000   0.000000   2.270000 (  2.270935)
    original   0.710000   0.000000   0.710000 (  0.709436)
    ----------------------------------- total: 2.980000sec

                   user     system      total        real
    mine       2.320000   0.000000   2.320000 (  2.321878)
    original   0.690000   0.000000   0.690000 (  0.692148)

Le score est sans appel ! Ma belle méthode sucre les fraises :(

Du coup j'ai bien envie de voir si je peux faire mieux que la méthode
originale ;) Soit en tentant d'améliorer ma méthode, soit en déroulant
un algorithme «à la C». On verra peut-être demain.

En attendant, vos solutions m'intéresse, n'hésitez pas à les envoyer dans
un commentaire.



À demain.


