---
layout: post
title: "Comportement inattendu de Rspec"
date: 2015-06-30 15:37
comments: true
categories: [ruby, rspec, test, intermédiaire]
---

{% level 2 %}

Je suis tombé aujourd'hui sur un comportement inattendu de Rspec.
Je ne dis pas que le comportement est mauvais, seulement je m'attendais à
autre chose qui me semble plus logique. Quoiqu'il en soit, je partage mes
réflexions avec vous.

<!-- more -->

J'utilise beaucoup Rspec que j'aime bien. Pourtant je connais assez mal sa
mécanique interne. Un pattern dont je me sers de temps
en temps est de définir des méthodes helper dans le fichier de test :

``` ruby spec/thing1_spec.rb
require 'spec_helper'

describe Thing1 do

  it "returns 'foo'" do
    expect(Thing1.new.get).to eq result
  end

end

def result
  'foo'
end
```

Avec `Thing1` défini ainsi :

``` ruby thing1.rb
class Thing1
  def get
    'foo'
  end
end
```

Ça marche très bien :


    $ rspec -I. spec/thing1_spec.rb 
    .

    Finished in 0.00184 seconds (files took 0.23569 seconds to load)
    1 example, 0 failures


Là où ça devient problématique, c'est si j'utilise le même nom de méthode helper
dans un autre fichier de test :

``` ruby spec/thing2_spec.rb
require 'spec_helper'

describe Thing2 do

  it "returns 'bar'" do
    expect(Thing2.new.get).to eq result
  end

end

def result
  'bar'
end
```

Avec `Thing2` comme ceci :

``` ruby thing2.rb
class Thing2
  def get
    'bar'
  end
end
```

Dans ce cas un test échoue :

    $ rspec -I.
    F.

    Failures:

      1) Thing1 returns 'foo'
         Failure/Error: expect(Thing1.new.get).to eq result
           
           expected: "bar"
                got: "foo"
           
           (compared using ==)
         # ./spec/thing1_spec.rb:6:in `block (2 levels) in <top (required)>'

    Finished in 0.00232 seconds (files took 0.21784 seconds to load)
    2 examples, 1 failure

    Failed examples:

    rspec ./spec/thing1_spec.rb:5 # Thing1 returns 'foo'

J'ai tenté de les jouer de différentes manières : seulement l'un, puis
seulement l'autre, Thing1 puis Thing2, Thing2 puis Thing1, pour voir…

J'en arrive à la conclusion que Rspec charge tous les fichiers de test avant de
démarrer un test. Comme Ruby est dynamique, c'est la dernière méthode `result` chargée qui, en quelque sorte, à raison.

La solution est donc simple, il faut *rentrer* les méthodes helper dans le
bloc `describe` :

``` ruby
require 'spec_helper'

describe Thing1 do

  it "returns 'foo'" do
    expect(Thing1.new.get).to eq result
  end

  def result
    'foo'
  end

end
```

Maintenant les deux tests fonctionnent comme attendu :

    $ rspec -I.
    ..

    Finished in 0.00283 seconds (files took 0.21533 seconds to load)
    2 examples, 0 failures

**Je m'attendais à ce que les différents fichiers de test soient joués en
isolation totale**, sans connexion si mince soit elle avec d'autres fichiers.
Manifestement c'est pas le cas.

Pour être exhaustif voici le contenu du *spec helper* :

``` ruby spec/spec_helper.rb
require 'thing1'
require 'thing2'
```

Et voici les fichiers :

    $ \tree
    .
    |-- spec
    |   |-- spec_helper.rb
    |   |-- thing1_spec.rb
    |   `-- thing2_spec.rb
    |-- thing1.rb
    `-- thing2.rb

Si vous avez un avis sur la question il m'intéresse beaucoup, n'hésitez donc pas à laisser un
commentaire.

{% connexe %}
