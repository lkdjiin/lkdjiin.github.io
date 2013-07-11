---
layout: post
title: "Ruby et les eigenclass"
date: 2013-07-11 10:24
comments: true
categories: [ruby, eigenclass, object]
---
Dans l'
[article d'hier](http://lkdjiin.github.io/blog/2013/07/10/quel-est-linteret-de-cette-syntaxe/),
je cherchais un intérêt à `class << self` dans la
définition d'une classe, et je n'en ai pas trouvé.
Aujourd'hui je vais appronfondir le sujet et parler des eigenclass(es) en Ruby.
Il se trouve que Ruby est un langage orienté objet, contrairement à…
(au hasard) Java…

<!-- more -->

Ok, c'est pour rire. Bien sûr que Java est un langage OO. Mais quand même,
par rapport à Ruby je dirais plutôt que Java est un langage orienté classe.
Avec Ruby, tout est objet, même les classes ! Je re-dis ça autrement
pour que ce soit
bien clair : en Ruby les classes sont des objets comme les autres.
Voyons comment ça fonctionne, au travers des eigenclass(es):

``` ruby
class Engin
  def roule
    "Je roule"
  end
end

voiture = Engin.new
moto = Engin.new

voiture.roule
# => "Je roule"
moto.roule
# => "Je roule"
```

On a créé une classe `Engin` et instancié deux objets à partir de cette
classe, `voiture` et `moto`. La classe a joué le rôle d'un moule, à partir
duquel les deux objets ont été fabriqués et leurs comportements sont
identiques. Maintenant, si on veut spécialiser le comportement de `moto`,
on pourrait utiliser l'héritage ou les mixins. Ce qui serait très bien si
on devait gérer des dizaines d'objets au comportement similaire. Mais si on
a un seul objet qui diffère, devoir écrire une nouvelle classe pour un seul
objet est un peu lourd. Grâce au eigenclass(es), Ruby permet de changer le
comportement d'un objet pendant l'execution.

``` ruby
class << moto
  def wheeling
    "Wahooo"
  end
end
```

Ou bien avec la syntaxe suivante, qui fait la même chose:

``` ruby
def moto.wheeling
  "Wahooo"
end
```

On vient d'ajouter une méthode à l'objet `moto` de classe `Engin`, mais pas
à l'objet `voiture`, pourtant lui aussi de classe `Engin`. Pour vérifier:


``` ruby
moto.wheeling
# => "Wahooo"

voiture.wheeling
# => NoMethodError: undefined method `wheeling'

voiture.class == moto.class
# => true
```

Comment Ruby gère ce système ? C'est surprenant de simplicité. Ruby interpose
une nouvelle classe, anonyme, entre l'objet et sa hiérarchie de classes. C'est
cette nouvelle classe, qu'on appelle eigenclass.
L'eigenclass ne comprend que les comportements ajoutés à «son» objet.  Dans
notre exemple, l'eigenclass de `moto` ne comporte que la méthode `wheeling`.
Le système de classe de Ruby est complexe, mais pour la partie qui nous
intéresse ici cela donne ça:

    moto < eigenclass < Engin < Object

À la place de «eigenclass», on peut lire et entendre parfois «singleton» ou
«metaclass», c'est la même chose. D'ailleurs, pour obtenir la liste des 
méthodes de la «ghost class» (encore un autre nom) on peut utiliser la
méthode `singleton_methods`:

``` ruby
moto.singleton_methods
# => [
# =>   [0] wheeling() #<Engin:0xa05585c>
# => ]
```

J'ai dit au début qu'une classe est un objet comme un autre. Donc ce qui
fonctionne pour `moto` doit aussi fonctionner pour `Engin`:

``` ruby
def Engin.definition
  "Un truc qui roule"
end

Engin.definition
# => "un truc qui roule"

Engin.singleton_methods
# => [
# =>     [0] definition() Engin
# => ]
```

Tout pareil ! `definition` a été ajouté à l'eigenclass de `Engin`.
Autrement dit, quand vous ajouter une méthode de classe à une classe, en fait
vous l'ajouter à son eigenclass.

À demain.
