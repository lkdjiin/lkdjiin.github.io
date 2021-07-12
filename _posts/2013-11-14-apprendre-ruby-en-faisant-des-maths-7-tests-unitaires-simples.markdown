---
layout: post
title: "Apprendre Ruby en faisant des maths 7: Tests unitaires simples"
date: 2013-11-14 13:22
legacy: true
tags: [ruby]
---



Si vous voulez vraiment apprendre Ruby, vous *devriez* aussi apprendre
à faire des tests automatisés: c'est le meilleur moyen d'avoir confiance
en son code. Et la question se pose de savoir quel framework utiliser ?
Il en existe plusieurs: unit/test, minitest, RSpec, Shoulda, Cucumber et
j'en oublie… Chaque développeur a ses préférences, et c'est bien normal.

`<opinion>`

Mais souvent les développeurs ont aussi des convictions, ce qui est parfois
problématique. Un framework de test est un outil, comme tant d'autres.
Un outil X peut être parfait pour telle application et bien moins bon pour
telle autre application. Autrement dit, **LE** framework de test n'existe
pas. Quand vous en aurez testé quelques uns, vous aurez une préférence,
d'accord, pas de soucis. Mais s'il vous plait, avant d'avoir une conviction,
attendez d'en avoir *utilisé* 3 ou 4, et chacun dans différents types de
projet.

`</opinion>`

<!-- more -->

Aujourd'hui on va apprendre à tester le module créé [la dernière fois](http://lkdjiin.github.io/blog/2013/11/01/apprendre-ruby-en-faisant-des-maths-6-methodes-utilitaires-et-module/)
à l'aide du framework test/unit. Pas parce que ce framework est le
meilleur, pas parce que j'ai une préférence pour ce framework mais parce qu'il
est livré avec Ruby et qu'il ne necessite donc pas d'installation.

Le fichier de test
------------------

Voici le code à mettre dans un fichier nommé `tc_number.rb`:

{% highlight ruby %}
require_relative "number"
require "test/unit"

class TestNumber < Test::Unit::TestCase
  def test_divisors
    assert_equal [1, 2, 4, 8], Number.divisors(4)
  end
end
{% endhighlight %}

Le fichier `tc_number.rb` contient le code pour tester notre module `Number`,
qui est dans le fichier `number.rb`. Veillez à garder les deux fichiers dans
le même dossier.

Explications
------------
Voici les explications, ligne par ligne:

    require_relative "number"

On charge notre module `Number`.

    require "test/unit"

On charge la bibliothèque `test/unit`, qui contient plusieurs classes/modules
et méthodes qui vont nous permettre d'écrire nos tests.

    class TestNumber < Test::Unit::TestCase

On crée une classe `TestNumber`. Vous remarquez que c'est le nom de notre
module à tester, préfixé par Test. Cette classe hérite de
`Test::Unit::TestCase`. Si vous ne savez pas encore ce qu'est une classe,
dites vous que c'est un module un peu spécial. Si vous ne savez pas
encore ce qu'est l'héritage, ce n'est pas grave.

    def test_divisors

On définit un test de la méthode `divisors`, à travers la méthodes
`test_divisors`. Vous remarquez que c'est le nom de notre méthode à tester,
préfixé par `test_`.

    assert_equal [1, 2, 4, 8], Number.divisors(4)

Voici enfin le test proprement dit. La méthode `assert_equal` s'assure
que ses deux arguments sont égaux. On veut savoir si `Number.divisors(4)`
est bien égal à l'Array (la liste) `[1, 2, 3, 4]`, *ce qui est faux*.

Utilisation
-----------

Voici la sortie:

    [~]⇒ ruby tc_number.rb 
    Run options: 

    # Running tests:

    F

    Finished tests in 0.002405s, 415.8087 tests/s, 415.8087 assertions/s.

      1) Failure:
    test_divisors(TestNumber) [tc_number.rb:6]:
    <[1, 2, 4, 8]> expected but was
    <[1, 2, 4]>.

    1 tests, 1 assertions, 1 failures, 0 errors, 0 skips

La section `1) Failure:` est particulièrement intéressante et nous indique
que la liste `[1, 2, 3, 4]` était attendue, mais que c'est la liste
`[1, 2, 4]` qui a été reçue.

Si on corrige notre test:

{% highlight ruby %}
require_relative "number"
require "test/unit"

class TestNumber < Test::Unit::TestCase
  def test_divisors
    assert_equal [1, 2, 4], Number.divisors(4)
  end
end
{% endhighlight %}

Cette fois-ci la sortie nous indique que tout va bien:

    [~]⇒ ruby tc_number.rb 
    Run options: 

    # Running tests:

    .

    Finished tests in 0.000644s, 1553.5887 tests/s, 1553.5887 assertions/s.

    1 tests, 1 assertions, 0 failures, 0 errors, 0 skips


Plus de tests
-------------

Nous pouvons ajouter un autre test pour la méthode `divisors`:

{% highlight ruby %}
  def test_divisors
    assert_equal [1, 2, 4], Number.divisors(4)
    assert_equal [1, 17], Number.divisors(17)
  end
{% endhighlight %}

Mais aussi tester les autres méthodes de notre module, selon le même
modèle:

{% highlight ruby %}
require_relative "number"
require "test/unit"

class TestNumber < Test::Unit::TestCase
  def test_divisors
    assert_equal [1, 2, 4], Number.divisors(4)
    assert_equal [1, 17], Number.divisors(17)
  end

  def test_proper_divisors
    assert_equal [1, 2], Number.proper_divisors(4)
    assert_equal [1], Number.proper_divisors(17)
  end

  def test_sum_of_proper_divisors
    assert_equal 3, Number.sum_of_proper_divisors(4)
    assert_equal 1, Number.sum_of_proper_divisors(17)
  end
end
{% endhighlight %}





À demain.



