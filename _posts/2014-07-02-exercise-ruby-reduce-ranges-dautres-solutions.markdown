---
layout: post
title: "Exercise Ruby - Reduce ranges - d'autres solutions"
date: 2014-07-02 21:03
legacy: true
tags: [ruby, intermédiaire]
---



Hier j'ai proposé [une solution](http://lkdjiin.github.io/blog/2014/07/01/exercise-ruby-reduce-ranges-une-solution/) à cet exercise de [Range reduce](http://lkdjiin.github.io/blog/2014/06/30/exercice-ruby-reduce-ranges/).
Bien qu'élégante (du moins pour moi), elle prenait vraiment trop de temps par
rapport à l'originale. En voici d'autres. Meilleures ?

<!-- more -->

Pour rappel, voici l'originale:

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

Et voici ma solution d'hier:

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

Maintenant, voici celle que j'ai eu en tête toute la journée:

{% highlight ruby %}
def range_reduce_1(array)
  temp = []
  result = []

  array.each do |element|
    if temp.empty?
      temp << element
    else
      if temp.last + 1 == element
        temp << element
      else
        if temp.size == 1
          result << temp.first
        else
          result << (temp.first..temp.last)
        end
        temp = [element]
      end
    end
  end

  if temp.size == 1
    result << temp.first
  else
    result << (temp.first..temp.last)
  end

  result
end
{% endhighlight %}

C'est moche, hein ? Mais ne riez quand même pas trop, attendez de voir les
benchmarks ;)

Je me suis dis que j'allais aussi tester une solution *propre*, avec un
pattern que j'aime beaucoup:

{% highlight ruby %}
class ArrayReduce

  def self.ranges(array)
    new(array).ranges
  end

  def initialize(array)
    @array = array
    @result = [ [@array.first] ]
  end

  def ranges
    @array[1..-1].each do |element|
      suite?(element) ? @result.last << element : @result << [element]
    end

    @result.map do |element|
      element.size == 1 ? element.first : element.first..element.last
    end
  end

  private

  def suite?(element)
    @result.last.last == element.pred
  end

end
{% endhighlight %}

Et voici la solution qu'a posté un lecteur, Calyhre. J'ai pris la liberté de
la transformer en méthode, comme j'ai fait pour la solution originale qui
*monkey patch* la classe Array ([solution originale de Calyhre](https://gist.github.com/Calyhre/280ee41136ad2a62e6c3)):

{% highlight ruby %}
def calyhre(array)
  temp = results = []
  array.each do |e|
    temp << e and next if temp.last == e - 1
    results << ( temp[1].nil? ? temp[0] : (temp.first..temp.last) ) unless temp.empty?
    temp = [e]
  end
  results << ( temp[1].nil? ? temp[0] : (temp.first..temp.last) )
end
{% endhighlight %}

Du coup, pour être équitable, il faudrait un autre benchmark pour les
*monkey patches* ! Peut-être plus tard.

Voici donc les résultats avec Ruby 2.1:

    $ 21:16 [~/devel/ruby/tests] (ruby-2.1.0) 
    $ ruby range_reduce.rb 
    Rehearsal --------------------------------------------------
    original         0.690000   0.000000   0.690000 (  0.694524)
    range_reduce     2.310000   0.000000   2.310000 (  2.305131)
    range_reduce_1   0.650000   0.000000   0.650000 (  0.648863)
    ArrayReduce      1.080000   0.000000   1.080000 (  1.088213)
    Calyhre          0.680000   0.000000   0.680000 (  0.676048)
    ----------------------------------------- total: 5.410000sec

                         user     system      total        real
    original         0.690000   0.000000   0.690000 (  0.692163)
    range_reduce     2.250000   0.000000   2.250000 (  2.253139)
    range_reduce_1   0.630000   0.000000   0.630000 (  0.636611)
    ArrayReduce      1.050000   0.010000   1.060000 (  1.077018)
    Calyhre          0.660000   0.000000   0.660000 (  0.662596)

Puis avec Rubinius 2.0:

    $ 21:19 [~/devel/ruby/tests] (rbx-2.0.0) 
    $ ruby range_reduce.rb 
    Rehearsal --------------------------------------------------
    original         1.984124   0.004000   1.988124 (  1.994156)
    range_reduce     3.220201   0.012001   3.232202 (  3.248281)
    range_reduce_1   0.620038   0.000000   0.620038 (  0.775944)
    ArrayReduce      1.156072   0.000000   1.156072 (  1.195206)
    Calyhre          0.788049   0.000000   0.788049 (  1.007030)
    ----------------------------------------- total: 7.784485sec

                         user     system      total        real
    original         1.008063   0.000000   1.008063 (  1.152041)
    range_reduce     2.504157   0.020001   2.524158 (  2.525078)
    range_reduce_1   0.320020   0.000000   0.320020 (  0.319301)
    ArrayReduce      0.652041   0.000000   0.652041 (  0.653359)
    Calyhre          0.352022   0.000000   0.352022 (  0.349252)

Ma méthode bien moche fonctionne plutôt bien ici :)



À demain.


