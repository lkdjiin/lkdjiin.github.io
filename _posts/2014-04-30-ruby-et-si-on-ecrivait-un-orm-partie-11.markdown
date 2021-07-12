---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 11"
date: 2014-04-30 21:39
legacy: true
tags: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---



On a dit qu'il était temps de *splitter* les fichiers, aussi bien pour
les tests que pour le code d'implémentation.

<!-- more -->

On commence par créer un dossier spec avec à l'intérieur le fichier
`database_spec.rb`:

{% highlight ruby %}
require './sorm'

describe SORM::Database do
  describe 'connection' do
    it 'is not connected' do
      expect(SORM::Database.connected?).to be false
    end

    describe 'after connection' do
      it 'is connected' do
        SORM::Database.connect('test.db')
        expect(SORM::Database.connected?).to be true
      end
    end
  end
end
{% endhighlight %}

Puis on vérifie que tout va bien:

    $ rspec spec/database_spec.rb 
    ..
    Finished in 0.00267 seconds
    2 examples, 0 failures

Au tour de la classe `Base` d'avoir son propre fichier de tests. Je vous
épargne le contenu des méthodes `it`, il n'a pas changé:

{% highlight ruby %}
require './sorm'

describe SORM::Base do
  class Article < SORM::Base ; end

  describe '.execute' do
    before do
      SORM::Database.execute("INSERT INTO article VALUES(1, 'Foo');")
      SORM::Database.execute("INSERT INTO article VALUES(2, 'Bar');")
    end

    after do
      SORM::Database.execute("DELETE FROM article;")
    end

    it 'returns the correct number of rows' do
      #
    end

    it 'returns correct values' do
      #
    end
  end

  describe 'object creation' do
    after { SORM::Database.execute("DELETE FROM article;") }

    it 'creates a record' do
      #
    end

    it 'returns an object with correct class' do
      #
    end

    it 'returns an object with correct attributes' do
      #
    end
  end
end
{% endhighlight %}

Place à la vérification:

    $ rspec spec/base_spec.rb 
    An error occurred in an after hook
      NoMethodError: undefined method `execute' for false:FalseClass
    [...]
    5 examples, 5 failures

Bah oui, ça ne devrait pas nous surprendre. Notre ancien fichier de
test *global* était mal conçu. On n'est plus connecté à la base de
données. Et là se pose la question de savoir si on doit se connecter
avant chaque test, dans un `before :each` ou bien une fois pour toute
au début du fichier, dans un `before :all` ? La seconde solution me parait
la plus adaptée, mais on pourra toujours en changer par la suite si besoin
est:

{% highlight ruby %}
describe SORM::Base do
  class Article < SORM::Base ; end

  before :all do
    SORM::Database.connect('test.db')
  end

[...]
{% endhighlight %}

Or relance les tests:

    $ rspec spec/base_spec.rb 
    .....
    Finished in 0.10185 seconds
    5 examples, 0 failures

Ok, cool. Reste encore à lancer les tests **au complet** avant de crier
victoire:

    $ rspec
    .....F.

    Failures:

      1) SORM::Database connection is not connected
         Failure/Error: expect(SORM::Database.connected?).to be false
           
           expected #<FalseClass:0> => false
                got #<TrueClass:2> => true
           
           Compared using equal?, which compares object identity,
           but expected and actual are not the same object. Use
           `expect(actual).to eq(expected)` if you don't care about
           object identity in this example.
         # ./spec/database_spec.rb:6:in `block (3 levels) in <top (required)>'

    Finished in 0.03452 seconds
    7 examples, 1 failure

    Failed examples:

    rspec ./spec/database_spec.rb:5 # SORM::Database connection is not connected

Et oui, on ne maitrise plus l'ordre des tests ! `base_spec.rb`, premier
dans l'ordre alphabétique a été joué avant, et donc `database_spec.rb` se
retrouve avec une base de données connectée.

On ajoutera donc la prochaine fois une méthode `disconnect`. Et ça me
fait penser aussi qu'il faudra configurer Rspec pour jouer les tests dans
un ordre aléatoire.

*To be continued*



À demain.



