---
layout: post
title: "Ruby - Utiliser les blocs pour faire du refactoring - partie 2"
date: 2014-03-10 15:58
legacy: true
tags: [ruby, refactoring, bloc, débutant]
---



Suite à l'article d'hier
([Utiliser les blocs pour faire du refactoring](/blog/2014/03/09/ruby-utiliser-les-blocs-pour-faire-du-refactoring/)),
on m'a demandé la différence entre `block.call` et `yield`. C'est parti.

<!-- more -->

On s'était arrêté là:

{% highlight ruby %}
class Bidule
  def un
    helper('un') { puts 'Au milieu de la méthode un' }
  end

  def deux
    helper('deux') do
      puts 'Ceci est le milieu de la méthode deux'
    end
  end

  private

  def helper(argument, &block)
    puts "Début de la méthode #{argument}"
    block.call
    puts "Fin de la méthode #{argument}"
  end
end

bidule = Bidule.new
bidule.un
bidule.deux
{% endhighlight %}

Essayons de remplacer `block.call` par `yield`:

{% highlight ruby %}
class Bidule
  def un
    helper('un') { puts 'Au milieu de la méthode un' }
  end

  def deux
    helper('deux') do
      puts 'Ceci est le milieu de la méthode deux'
    end
  end

  private

  def helper(argument, &block)
    puts "Début de la méthode #{argument}"
    yield
    puts "Fin de la méthode #{argument}"
  end
end

bidule = Bidule.new
bidule.un
bidule.deux
{% endhighlight %}

Lorsqu'on lance le programme, on voit qu'il n'y a pas de différences:

{% highlight bash %}
$ ruby test.rb 
Début de la méthode un
Au milieu de la méthode un
Fin de la méthode un
Début de la méthode deux
Ceci est le milieu de la méthode deux
Fin de la méthode deux
{% endhighlight %}

Ok, donc `block.call` et `yield` c'est pareil ? Attends encore. Essayons
maintenant de supprimer le `&block`:

{% highlight ruby %}
class Bidule
  def un
    helper('un') { puts 'Au milieu de la méthode un' }
  end

  def deux
    helper('deux') do
      puts 'Ceci est le milieu de la méthode deux'
    end
  end

  private

  def helper(argument)
    puts "Début de la méthode #{argument}"
    yield
    puts "Fin de la méthode #{argument}"
  end
end

bidule = Bidule.new
bidule.un
bidule.deux
{% endhighlight %}

Toujours pas de différences ! Par contre, on ne pourra pas appeler
`block.call` sans avoir défini `&block`:

{% highlight ruby %}
  def helper(argument)
    puts "Début de la méthode #{argument}"
    block.call
    puts "Fin de la méthode #{argument}"
  end
{% endhighlight %}

Le code ci-dessus donnera évidemment une erreur:

{% highlight bash %}
$ ruby test.rb 
Début de la méthode un
test.rb:16:in `helper': undefined local variable or method `block' for
#<Bidule:0x9eaf6ec> (NameError)
{% endhighlight %}

Toutes ces expérimentations nous ammène à une première conclusion: *Les
blocs sont implicites, et donc ils sont partout*. Ce que confirme, s'il en
est encore besoin, la session irb suivante:


{% highlight irb %}
>> def foo(arg)
>>   puts arg
>> end
=> :foo
>> foo('ok') { puts 'I am in a block' }
ok
{% endhighlight %}

Le contenu du bloc n'est jamais évalué, mais ne provoque pas d'erreur
lors de l'appel de `foo`.

Seconde conclusion, `block.call` et `yield` fonctionnent à l'identique.
Bien que je préfère `block.call`, qui me force à documenter la méthode
avec le `&block`.




À demain.



