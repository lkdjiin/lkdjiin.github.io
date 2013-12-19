---
layout: post
title: "Écrire un DSL en Ruby facilement avec Docile"
date: 2013-08-14 10:41
comments: true
categories: [ruby, dsl, intermédiaire]
---

{% level 2 %}

Je suis en train de lire «[A new kind of science](http://www.wolframscience.com/)» de Stephen Wolfram
et ça me donne envie de me replonger dans les [automates cellulaires](https://fr.wikipedia.org/wiki/Automate_cellulaire).
Le jeu de la vie est sûrement le programme que j'ai écrit le plus souvent,
mais curieusement jamais en Ruby.

<!-- more -->

J'ai commencé à écrire un
[framework pour automate cellulaire](https://github.com/lkdjiin/cellula),
qui n'aboutira peut-être pas faute de temps. Quoiqu'il en soit, je voudrais
que ce framework soit utilisable par des non-développeurs, d'où le recours
à un DSL (Domain Specific Language). Et pour développer mon DSL, je n'ai
pas trouver plus simple que la gem
[docile](https://github.com/ms-ati/docile).


Voici le DSL que je voudrais:

``` ruby my_automaton.rb
automaton "Test Automaton" do
  dimensions       2
  type             :elementary
  width            100
  height           100
  rule             :b36s26
  pattern          :random
  live_probability 0.1789
end
```

Docile encourage l'utilisation du design pattern builder. Alors allons-y
pour une classe builder qui va contenir les valeurs par défaut de notre
futur Automaton:

``` ruby automaton_builder.rb
class AutomatonBuilder
  def initialize(name)
    @name = name
    @dimensions = 2
    @type = :elementary
    @width = 0
    @height = 0
    @rule = :b3s23
    @pattern = :random
    @live_probability = 0.5
  end

  def dimensions(val); @dimensions = val; self; end
  def type(val); @type = val; self; end
  def width(val); @width = val; self; end
  def height(val); @height = val; self; end
  def rule(val); @rule = val; self; end
  def pattern(val); @pattern = val; self; end
  def live_probability(val); @live_probability = val; self; end

  def build
    Automaton.new(@name, @dimensions, @type, @width, @height,
                  @rule, @pattern, @live_probability)
  end
end
```

Il nous faut maintenant une classe Automaton:

``` ruby automaton.rb
class Automaton
  def initialize(name, dimensions, type, width, height, rule,
                pattern, live_probability)
    @name = name
    @dimensions = dimensions
    @type = type
    @width = width
    @height = height
    @rule = rule
    @pattern = pattern
    @live_probability = live_probability
  end

  def run
    puts "#{@name} running"
  end
end
```

Et pour finir, on demande à Docile d'évaluer notre DSL puis on charge le
fichier `my_automaton.rb`. Il ne reste plus qu'à lancer la machine:

``` ruby main.rb
require 'docile'
require './automaton_builder'
require './automaton'

def automaton(name, &block)
  @auto = Docile.dsl_eval(AutomatonBuilder.new(name), &block).build
end

load ARGV[0]

@auto.run
```

La boucle est bouclée. Vous remarquerez que la méthode `automaton` définie
dans `main.rb` ci-dessus est celle qui est utilisée dans le DSL
(`my_automaton.rb`).

    $ ruby ./main.rb my_automaton.rb 
    Test Automaton running

Et voilà. C'est presque trop facile d'écrire un DSL avec Docile…



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
