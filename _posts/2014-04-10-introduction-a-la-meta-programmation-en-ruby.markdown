---
layout: post
title: "Introduction à la meta-programmation en Ruby"
date: 2014-04-10 21:15
legacy: true
tags: [ruby, intermédiaire, meta, programmation]
---



La méta programmation, qu'est-ce que c'est ? C'est le fait
de *modifier* le code au moment de l'exécution d'un
programme. Par modifier, il faut aussi entendre créer et
supprimer. C'est un peu le pendant naturel de
[l'introspection](http://lkdjiin.github.io/blog/2014/04/08/introduction-a-lintrospection-en-ruby/) dont j'ai parlé récemment.

<!-- more -->

Pour cette introduction au concept de méta programmation, on
va y aller en douceur. Prenons la bête classe suivante:

{% highlight ruby %}
class Greeting
  def alphonse
    'Hello Alphonse'
  end
end

puts Greeting.new.alphonse

#=> Hello Alphonse
{% endhighlight %}

On définit la méthode `alphonse` de manière classique:

    def alphonse
      'Hello Alphonse'
    end

C'est comme ça qu'on fait tous les jours ;) En fait cette
façon de définir la méthode `alphonse` est du
[sucre syntaxique](http://fr.wikipedia.org/wiki/Sucre_syntaxique). Ruby est bourré de sucre syntaxique.
Pour définir notre méthode `alphonse` on pourrait utiliser…
une méthode ! Voyons l'exemple suivant:

{% highlight ruby %}
class Greeting
  define_method('alphonse') { 'Hello Alphonse' }
end

puts Greeting.new.alphonse

#=> Hello Alphonse
{% endhighlight %}

Le résultat est identique, et pour cause: c'est la même
méthode, on l'a simplement définit autrement.

On a donc:

    def alphonse
      'Hello Alphonse'
    end

qui est identique à:

    define_method('alphonse') { 'Hello Alphonse' }

Alors ça nous fait une belle jambe ! Parce que honnêtement,
qu'est-ce qu'on y gagne ? Pas en lisibilité en tous cas.
Alors quoi ? Un indice: **on a utilisé une méthode pour
définir une méthode**. Ce qui nous permet de faire ce qui
suit:

{% highlight ruby %}
class Greeting
  ['alphonse', 'charlotte', 'marcel'].each do |method|
    define_method(method) { "Hello #{method.capitalize}" }
  end
end

puts Greeting.new.alphonse
puts Greeting.new.charlotte
puts Greeting.new.marcel

#=> Hello Alphonse
#=> Hello Charlotte
#=> Hello Marcel
{% endhighlight %}

Bon, on a toujours pas gagné en lisibilité. Par contre on
gagne en compacité, imaginez un peu si il y avait 20
méthodes.

Et sinon, concrètement, ça sert à quoi ? Sans cette
capacité de méta programmation, comment feriez vous si,
mettons, les noms des méthodes à implémenter ne sont pas
connus au lancement du programme ? C'est par exemple une
grande par de la *magie* de Rails. Dans Rails vous pouvez
chercher `User.find_by_name('charlotte')` alors même que
vous n'avez nulle-part définit cette méthode. C'est grâce
à la méta programmation.

Ça me donne l'idée de faire quelques prochains articles sur
ce sujet.



À demain.



