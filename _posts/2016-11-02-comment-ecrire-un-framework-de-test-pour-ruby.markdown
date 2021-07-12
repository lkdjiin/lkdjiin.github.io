---
layout: post
title: "Comment écrire un framework de test pour Ruby"
date: 2016-11-02 09:06
legacy: true
tags: [ruby, framework, test]
---

Si vous souhaitez comprendre le fonctionnement d'un framework de test, si vous
voulez écrire votre propre framework et que vous ressentiez le besoin d'un coup
de pouce, cet article est fait pour vous. Nous verrons étape par étape comment écrire
une telle chose. Le framework que nous réaliserons tiendra en quelques dizaines de
lignes de Ruby et pourra être utilisé comme une base pour vos futures
réalisations.

{% img center /images/colorful-test-tubes.jpg %}

<!-- more -->

## Par où commencer ?

Pour ce genre de problématique, je trouve qu'il est plus simple de partir d'un
exemple concret du **langage**, de l'**API**, que l'on souhaite obtenir. Dans notre
cas, nous pouvons déjà écrire quelques tests même si nous ne pouvons pas encore
les faire tourner.

Voici 3 tests pour une classe Rover. Classe qui aura une position x,y et une
direction :

{% highlight ruby %}
# fichier test_rover.rb final.

require 'rover'

class TestRover < Tasty::Unit

  def test_it_has_a_position
    rover = Rover.new(3, 2)
    assert(rover.position == [3, 2])
  end

  def test_it_has_a_direction_by_default
    rover = Rover.new(3, 2)
    assert(rover.direction == 'north')
  end

  def test_it_has_a_given_direction
    rover = Rover.new(3, 2, 'west')
    assert(rover.direction == 'west')
  end

end
{% endhighlight %}

J'ai cherché à faire au plus simple. Tout se passe à l'intérieur d'une classe.
Ça nous permettra d'hériter facilement de certains comportements, comme la
méthode `assert` qui sera définit dans la classe `Tasty::Unit`.

Chaque méthode qui commence par `test_` représente un test, et `assert` se
contente de vérifier si son argument est vrai ou faux.

On lancera le programme avec le nom d'un fichier de test, par exemple
`tasty test_rover.rb`. Mais par souci de simplicité, nous nous contenterons
d'utiliser directement l'interpréteur Ruby de cette manière :
`ruby tasty.rb test_rover.rb`.

Voici ce que j'imagine en terme d'affichage :

    $ ruby tasty.rb test_rover.rb
    ok - test_it_has_a_position
    not ok - test_it_has_a_given_direction
    << ERROR REPORT GOES HERE >>
    ok - test_it_has_a_direction_by_default

Le nom d'un test est précédé de "ok" si il a réussi, ou de "not ok" si il a
échoué. Le rapport d'erreur est affiché aussitôt après une ligne "not ok".

## Retrouver la classe de test

Commençons par le plus simple, définissons une classe Rover dans un fichier
`rover.rb` :

{% highlight ruby %}
# fichier rover.rb

class Rover
end
{% endhighlight %}

Puis définissons notre premier test, dans un fichier `test_rover.rb`. Ce
premier test va nous guider pendant un bout de temps :

{% highlight ruby %}
# fichier test_rover.rb

require_relative 'rover'

class TestRover < Tasty::Unit

  def test_it_has_a_position
    rover = Rover.new(3, 2)
    assert(rover.position == [3, 2])
  end

end
{% endhighlight %}

Maintenant, dans un fichier `tasty.rb`, définissons le namespace Tasty et une
classe principale. Nous initialiserons cette classe avec le nom de fichier
passé en argument sur la ligne de commande. Nous afficherons un message
temporaire pour nous assurer que nous sommes sur la bonne voie :

{% highlight ruby %}
# fichier tasty.rb

module Tasty

  class Main
    def initialize(filename)
      puts "Testing #{filename}"
    end
  end

end

main = Tasty::Main.new(ARGV[0])
{% endhighlight %}

L'essai est concluant :

    $ ruby tasty.rb test_rover.rb
    Testing test_rover.rb

Tant qu'on y est, mieux vaut définir tout de suite la classe `Tasty::Unit`,
voici à quoi devrait ressembler votre fichier `tasty.rb` :

{% highlight ruby %}
# fichier tasty.rb

module Tasty

  class Unit
  end

  class Main
    def initialize(filename)
      puts "Testing #{filename}"
    end
  end

end

main = Tasty::Main.new(ARGV[0])
{% endhighlight %}


Passons maintenant au sujet principal de cette section : nous devons retrouver
le nom de la classe de test, à savoir `TestRover`, depuis la classe
`Tasty::Main`. Pour ce faire nous pourrions écrire un parser qui
analyserait le contenu du fichier passé en argument. Ou bien nous pouvons
compter sur les facilités d'introspection du langage Ruby. Je parie volontiers
sur cette seconde solution. Nous laisserons Ruby charger et parser le fichier de
test pour nous. Nous chargerons le fichier de la même manière qu'un autre, avec
un `require`. Puis nous utilerons `Object.constants` pour accéder à toutes les
constantes définies jusqu'ici (une classe est représentée par une constante) :

{% highlight ruby %}
module Tasty

  class Main
    def initialize(filename)
      require File.join(Dir.pwd, filename)
      puts Object.constants
    end
  end

end
{% endhighlight %}

Si vous lancez ce programme, vous verrez une liste de toutes les constantes
définies, dont celle que nous cherchons, `TestRover` :

    $ ruby tasty.rb test_rover.rb 
    Object
    Module
    Class
    BasicObject
    ...
    SimpleDelegator
    Tasty
    Rover
    TestRover # <============================
    RUBYGEMS_ACTIVATION_MONITOR

Attention, il s'agit d'un tableau de symboles. Vous pouvez vous en convaincre
en changeant de méthode d'affichage. Remplacez `puts` par `p` :

{% highlight ruby %}
def initialize(filename)
  require File.join(Dir.pwd, filename)
  p Object.constants
end
{% endhighlight %}

Vous pouvez voir qu'il s'agit de symboles :

    $ ruby tasty.rb test_rover.rb 
    [:Object, :Module, :Class, :BasicObject, :Kernel, :NilClass, :NIL, :Data,
    ...
    :SimpleDelegator, :Tasty, :Rover, :TestRover, :RUBYGEMS_ACTIVATION_MONITOR]

Nous pouvons sélectionner uniquement les classes commençant par `Test` :

{% highlight ruby %}
# fichier tasty.rb

module Tasty

  class Unit
  end

  class Main
    def initialize(filename)
      require File.join(Dir.pwd, filename)
      p Object.constants.select { |name| name.to_s.start_with?('Test') }
    end
  end

end

main = Tasty::Main.new(ARGV[0])
{% endhighlight %}

Nous avons réduit le tableau aux seules classes de test. Nous en avons une
seule ici, mais nous pourrions très bien en avoir plusieurs :

    $ ruby tasty.rb test_rover.rb 
    [:TestRover]

Il y a une convention qui est à l'oeuvre : seule une classe de test peut
commencer par `Test`. Ça n'est pas un bien grand sacrifice, et nous pourrions
y remédier si besoin.

## Les méthodes de test

La prochaine étape consistera à récupérer les méthodes qui sont dans la classe
de test, et à les lancer.

Un peu de recherche, dans une session irb et avec la [documentation Ruby](http://ruby-doc.org/),
nous montrera que nous pouvons transformer un symbole en une classe, et aussi
instancier cette classe, à l'aide de `Object.const_get` :

{% highlight irb %}
$ irb
>> :Module
:Module
>> Object.const_get(:Module)
Module < Object
>> Object.const_get(:Module).new
#<Module:0x0055e0036e5580>
{% endhighlight %}
On peut donc transformer notre tableau de symboles selon cette méthode :

{% highlight ruby %}
class Main
  def initialize(filename)
    require File.join(Dir.pwd, filename)
    classes = Object.constants.select { |name| name.to_s.start_with?('Test') }
    classes.map! { |name| Object.const_get(name) }
  end
end
{% endhighlight %}

Retournons dans une session irb pour voir comment obtenir les méthodes d'une
classe quelconque.  Définissons une classe `C` avec une méthode
`method_in_class_c` pour les besoins de la cause :

{% highlight irb %}
$ irb
>> class C
>>   def method_in_class_c; end
>> end
{% endhighlight %}

La méthode `instance_methods` appliquée sur une classe liste les méthodes de
cette classe. Nous retrouvons notre méthode `method_in_class_c`, parmi plein
d'autres :

{% highlight irb %}
>> puts C.instance_methods
method_in_class_c # <--------------------
methods
singleton_methods
protected_methods
private_methods
public_methods
instance_of?
...
{% endhighlight %}

D'où viennent ces autres méthodes ? Ce sont les méthodes héritées ou incluses.
Pour restreindre les méthodes à celles définies dans la classe C, nous devons
utiliser un artifice :

{% highlight irb %}
>> puts C.instance_methods(false)
method_in_class_c
{% endhighlight %}

Nous pouvons nous servir de ce nouveau savoir pour lister les méthodes de test :

{% highlight ruby %}
# fichier tasty.rb

module Tasty

  class Unit
  end

  class Main
    def initialize(filename)
      require File.join(Dir.pwd, filename)
      classes = Object.constants.select { |name| name.to_s.start_with?('Test') }
      classes.map! { |name| Object.const_get(name) }
      
      classes.each do |c|
        c.instance_methods(false).each do |m|
          puts m
        end
      end
    end
  end

end

main = Tasty::Main.new(ARGV[0])
{% endhighlight %}

Nous l'avons trouvé :

    $ ruby tasty.rb test_rover.rb 
    test_it_has_a_position

Il reste à lancer chaque test en se servant de la méthode [send](http://ruby-doc.org/core-2.3.1/Object.html#method-i-send) sur une
instance de la classe de test. Nous ferons cela ailleurs que dans le
constructeur de la classe Tasty::Main. Dans une méthode `run` par exemple, ça
sera plus propre :

{% highlight ruby %}
# fichier tasty.rb

module Tasty

  class Unit
  end

  class Main
    def initialize(filename)
      require File.join(Dir.pwd, filename)
      @classes = Object.constants.select { |name| name.to_s.start_with?('Test') }
      @classes.map! { |name| Object.const_get(name) }
    end

    def run
      @classes.each do |class_under_test|
        instance = class_under_test.new
        class_under_test.instance_methods(false).each do |m|
          instance.send(m)
        end
      end
    end
  end

end

main = Tasty::Main.new(ARGV[0])
main.run
{% endhighlight %}

Alors, et si on lançait les tests :

    $ ruby tasty.rb test_rover.rb 
    test_rover.rb:6:in `initialize':
      wrong number of arguments (given 2, expected 0) (ArgumentError)
      from test_rover.rb:6:in `new'
      from test_rover.rb:6:in `test_it_has_a_position'

Déçu ? Vous ne devriez pas, ça a parfaitement fonctionné. Le programme nous dit
qu'en ligne 6 du fichier `test_rover.rb` nous tentons d'initialiser un rover
avec 2 arguments alors que la méthode `initialize` de rover attends 0
arguments. Voyons cette fameuse ligne 6, dans le test nous cherchons à
initialiser un rover avec des coordonnées x et y :

{% highlight ruby %}
rover = Rover.new(3, 2)
{% endhighlight %}

Et comme notre classe `Rover` est déséspérement vide, il est normal que Ruby
crashe.

## Passons le premier test

Dotons la méthode `Rover#initialize` de deux arguments, comme attendu :

{% highlight ruby %}
# fichier rover.rb
class Rover
  def initialize(x, y)
  end
end
{% endhighlight %}

Et le programme nous emmène au prochain problème :

    $ ruby tasty.rb test_rover.rb 
    test_rover.rb:7:in `test_it_has_a_position': undefined method `position'
    for #<Rover:0x0055778cf43a90> (NoMethodError)

On en vient facilement à bout en ajoutant la méthode `Rover#position` :

{% highlight ruby %}
# fichier rover.rb
class Rover
  def initialize(x, y)
  end

  def position
  end
end
{% endhighlight %}

L'erreur suivante est beaucoup plus intéressante :

    $ ruby tasty.rb test_rover.rb 
    test_rover.rb:7:in `test_it_has_a_position': undefined method `assert'
    for #<TestRover:0x00558edbe7a828> (NoMethodError)

Nous devons coder `assert` de telle manière qu'elle produise une erreur si son
argument est différent de `true`.  Et pour que les classes de test puissent y
accéder, nous la placerons dans `Tasty::Unit`. Nous utiliserons aussi une erreur
custom, `AssertionError` :

{% highlight ruby %}
module Tasty

  class AssertionError < StandardError
  end

  class Unit
    def assert(boolean)
      raise AssertionError unless boolean
    end
  end

end
{% endhighlight %}

Nous y sommes presque. La méthode `assert` est codée et produit l'erreur attendue :

    $ ruby tasty.rb test_rover.rb 
    tasty.rb:8:in `assert': Tasty::AssertionError (Tasty::AssertionError)
      from test_rover.rb:7:in `test_it_has_a_position'

Que se passerait-il si nous implémentions `Rover` de telle manière qu'elle
passe le test ?

{% highlight ruby %}
# fichier rover.rb
class Rover
  def initialize(x, y)
    @x = x
    @y = y
  end

  def position
    [@x, @y]
  end
end
{% endhighlight %}

Et bien rien. Il ne se passe rien.

    $ ruby tasty.rb test_rover.rb 
    $ # <---- Cruelle absence d'affichage

En l'occurence, ce rien signifie quand même que nous avons réussi cette
partie !  Le test est passé ! Ajoutons un petit quelque chose pour être tenu au
courant :

{% highlight ruby %}
module Tasty
  class Main
    def run
      @classes.each do |class_under_test|
        instance = class_under_test.new
        class_under_test.instance_methods(false).each do |m|
          instance.send(m)
          puts "ok - #{m}" # <---------------
        end
      end
    end
  end
end
{% endhighlight %}

Et c'est la victoire :

{% highlight raw %}
$ ruby tasty.rb test_rover.rb 
ok - test_it_has_a_position
{% endhighlight %}

## Les autres tests

Ajoutons le second test, mais plaçons le avant le premier (!) pour observer un
phénomène curieux :

{% highlight ruby %}
# fichier test_rover.rb
require_relative 'rover'

class TestRover < Tasty::Unit
  
  def test_it_has_a_direction_by_default
    rover = Rover.new(3, 2)
    assert(rover.direction == 'north')
  end

  def test_it_has_a_position
    rover = Rover.new(3, 2)
    assert(rover.position == [3, 2])
  end

end
{% endhighlight %}

Le programme reporte bien le nouveau problème qui se trouve dans la méthode
`test_it_has_a_direction_by_default` mais il n'y a aucune mention de
`test_it_has_a_position` qui fonctionnait pourtant bien.

    $ ruby tasty.rb test_rover.rb 
    test_rover.rb:7:in `test_it_has_a_direction_by_default': undefined method
    `direction' for #<Rover:0x0055a03b444db0 @x=3, @y=2> (NoMethodError)

Lorsqu'une erreur se produit dans `Tasty::Main#run`, le programme s'arrête
purement et simplement. Ce n'est pas du tout ce que nous voulons. Nous voulons
qu'une erreur soit rapportée, et que le programme continue en traitant le test
suivant. Commençons par remanier un peu la méthode `run` en la splittant en
deux parties :

{% highlight ruby %}
class Main
  def run
    @classes.each do |under_test|
      instance = under_test.new
      under_test.instance_methods(false).each { |m| run_test(instance, m) }
    end
  end

  def run_test(instance, method)
    instance.send(method)
    puts "ok - #{m}"
  end
end
{% endhighlight %}

Nous pouvons alors *attraper* les erreurs facilement dans la méthode `run_test` :

{% highlight ruby %}
  def run_test(instance, method)
    instance.send(method)
    puts "ok - #{method}"
  rescue => ex
    puts "not ok - #{method}"
    puts ex.inspect
    puts ex.backtrace
  end
{% endhighlight %}

Et voilà le résultat, nous affichons à la fois les tests qui passent et ceux
qui échouent :

    $ ruby tasty.rb test_rover.rb 
    not ok - test_it_has_a_direction_by_default
    #<NoMethodError: undefined method `direction' for #<Rover:0x0055a7709c03c0 @x=3, @y=2>>
    test_rover.rb:7:in `test_it_has_a_direction_by_default'
    ...
    ok - test_it_has_a_position

En dotant `Rover` de la méthode `position` qui suit, les tests passent :

{% highlight ruby %}
def position
  'north'
end
{% endhighlight %}

    $ ruby tasty.rb test_rover.rb 
    ok - test_it_has_a_direction_by_default
    ok - test_it_has_a_position

Faire passer le 3ème test implique seulement d'implémenter la classe `Rover` de
façon correcte. Il n'y a rien à ajouter ou à modifier dans notre framework
`Tasty`.

## Conclusion

Nous venons d'écrire un framework de test en quelques dizaines de lignes de
code grâce aux facultés d'introspection de Ruby. C'est maintenant à votre tour
de jouer en l'améliorant.  Voici quelques idées :

- Faire jouer les tests dans un ordre aléatoire
- Afficher une ligne de résultat final : `X tests, Y errors`
- La sortie console devrait se faire en couleur, les lignes "ok" en vert, les
  lignes "not ok" en rouges, et le reste en normal
- Écrire `ok - it has a position` plutôt que `ok - test_it_has_a_position`
- Faire en sorte que des classes autres que celles de test puissent commencer par `Test`.
- Le must pour un compilateur, c'est d'être écrit dans son langage. Faire
  pareil ici : tester Tasty avec Tasty

Pour finir, voici le code complet :

{% highlight ruby %}
# fichier rover.rb
class Rover
  def initialize(x, y, direction='north')
    @x = x
    @y = y
    @direction = direction
  end

  def position
    [@x, @y]
  end

  attr_reader :direction
end
{% endhighlight %}

{% highlight ruby %}
# fichier test_rover.rb
require_relative 'rover'

class TestRover < Tasty::Unit

  def test_it_has_a_direction_by_default
    rover = Rover.new(3, 2)
    assert(rover.direction == 'north')
  end

  def test_it_has_a_position
    rover = Rover.new(3, 2)
    assert(rover.position == [3, 2])
  end

  def test_it_has_a_given_direction
    rover = Rover.new(3, 2, 'west')
    assert(rover.direction == 'west')
  end

end
{% endhighlight %}

{% highlight ruby %}
# fichier tasty.rb
module Tasty

  class AssertionError < StandardError
  end

  class Unit
    def assert(boolean)
      raise AssertionError unless boolean
    end
  end

  class Main
    def initialize(filename)
      require File.join(Dir.pwd, filename)
      @classes = Object.constants.select { |name| name.to_s.start_with?('Test') }
      @classes.map! { |name| Object.const_get(name) }
    end

    def run
      @classes.each do |under_test|
        instance = under_test.new
        under_test.instance_methods(false).each { |m| run_test(instance, m) }
      end
    end

    def run_test(instance, method)
      instance.send(method)
      puts "ok - #{method}"
    rescue => ex
      puts "not ok - #{method}"
      puts ex.message
      puts ex.backtrace
    end
  end

end

main = Tasty::Main.new(ARGV[0])
main.run
{% endhighlight %}

Bons tests ! À plus tard.


