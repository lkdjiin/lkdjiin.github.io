---
layout: post
title: "Comment j'ai amélioré mon Ruby avec des contrats"
date: 2015-07-13 12:42
comments: true
categories: [guest, ruby, contrat]
---

## `{ Guest Post }`

Mes aventures avec une quantité de langages m'ont permis d'entrevoir de nouvelles approches et techniques.
Par exemple, un des gros apports d'Haskell sont les [Types](http://lyah.haskell.fr/creer-nos-propres-types-et-classes-de-types) et dans Erlang/Elixir le [Pattern-matching](http://learnyousomeerlang.com/syntax-in-functions) est roi.
Professionnellement je code principalement en Ruby et je rêvais d'avoir un système de Types avancé ainsi que du pattern-matching.
C'est ainsi que j'ai découvert une super gem [Contracts.ruby](https://github.com/egonSchiele/contracts.ruby) et dans cet article je vais essayer de vous présenter le [Design par Contrats](https://en.wikipedia.org/wiki/Design_by_contract) à travers l'utilisation de cette gem.

<!-- more -->

## Qu'est-ce qu'un contrat ?

Un contrat permet de s'assurer de ce qu'une méthode attend en entrée (pré-condition), de ce qu'elle produit en sortie (post-condition). Il va définir comment notre méthode se comporte mais aussi vérifier ce comportement.
La gem `Contracts.ruby` nous permet de décorer nos méthodes avec du code qui va vérifier que les entrées et les sorties correspondent à ce que le contrat spécifie. Bien sûr, on est pas obligé d'annoter chacune de nos méthodes mais je pense que spécifier le contrat sur toutes celles qui sont publiques ne peut qu'être bénéfique.

## Un premier exemple

```ruby
Contract Num, Num => Num
def add(a, b)
  a + b
end
```

Le contrat de ma méthode est `Contract Num, Num => Num` ce qui nous indique que la méthode *add* prend deux nombres en entrée et retourne un nombre. Simple, non ?
Vous allez me dire que ok, c'est de la documentation, j'aurais pu juste ajouter un commentaire. Mais, puisqu'il s'agit d'un contrat, la gem Contracts.ruby va permettre de nous assurer que celui-ci est respecté.

```ruby
require 'contracts'

class Foo
  include Contracts

  Contract Num, Num => Num
  def self.add(a, b)
    a + b
  end
end
```

`Foo.add(1, 2)` nous retourne évidemmement `3` par contre `Foo.add(1, '2')` va retourner:

```ruby
ParamContractError: Contract violation for argument 2 of 2:
        Expected: Num,
        Actual: "2"
        Value guarded in: Foo::add
        With Contract: Num, Num => Num
```

L'erreur nous montre que le contrat de la méthode *add* n'a pas été respecté par le second paramètre que nous lui avons passé, '2', car il n'est pas du type *Num*.

Notez que l'on doit toujours spécifier le type de la valeur retournée même si la méthode ne retourne rien:

```ruby
Contract String => nil
def hello(name)
  puts "hello, #{name}!"
end
```

Par exemple, si notre méthode retourne plusieurs valeurs, sa signature sera `Contract Num => [Num, Num]`.

## Les différents Types à notre disposition

Outre les classiques *Num*, *String*, *Bool*, nous avons à notre disposition des types plus intéressants comme:

- `Any` lorsque votre argument n'a pas de contrainte
- `None` lorsqu'on n'a pas d'argument
- `Or` si notre argument peut être de plusieurs types, par exemple `Or[Fixnum, Float]`
- `Not` si notre argument ne peut pas être d'un certain type, par exemple `Not[nil]`
- `Maybe` si notre argument est optionnel, par exemple `Maybe[String]`

Et bien d'autres que vous pourrez découvrir dans la documentation.

## Contrats sur des Types avancés

On peut utiliser des contrats avec des Types plus avancés comme des listes:

```ruby
Contract ArrayOf[Num] => Num
def multiply(vals)
  vals.reduce(:*)
end
```

Le contrat de la méthode *multiply* nous indique qu'elle attend une liste de valeurs du type Num. Par conséquent on peut faire `multiply([2, 4, 16])` mais pas `multiply([2, 4, 'foo'])`.

Des Hash:

```ruby
Contract ({ nom: String, age: Num, ville: String }) => nil
```

Des méthodes:

```ruby
Contract ArrayOf[Any], Proc => ArrayOf[Any]
```

Si vous utilisez les arguments nommés de Ruby 2.x, le contrat ressemblera à:

```ruby
Contract KeywordArgs[foo: String, bar: Num] => String
```

On peut aussi définir nos propres contrats grâce aux `synonymes`:

```ruby
Token = String
Client = Or[Hash, nil]

Contract Token => Client
def authenticate(token)
```

Notre méthode est ainsi plus claire quant à ce qu'elle attend et ce qu'elle permet de faire. On désire un `Token` qui est de type `String` en entrée et on retourne un `Client` qui peut être un `Hash` ou rien (nil).

## Le pattern-matching

Le pattern-matching consiste, pour une valeur donnée, à tester si elle correspond à un motif ou pas. Si c’est le cas une action est déclenchée. C'est un peu comme de l'overloading de méthode en Java. On pourrait l'imaginer comme un switch case géant mais en beaucoup plus élégant.

Un exemple simple avec le calcul (pas efficace du tout) de la suite de Fibonacci:

```ruby
Contract 0 => 0
def fib(n)
  0
end

Contract 1 => 1
def fib(n)
  1
end

Contract Num => Num
def fib(n)
  fib(n-1) + fib(n-2)
end
```

Pour un argument donné, chaque méthode va être essayée dans l'ordre. La première méthode qui ne génère pas d'erreur sera utilisée.

Un exemple un peu plus utile, la gestion d'une réponse HTTP en fonction de son code:

```ruby
Contract 200, JsonString => JsonString
def handle_response(status, response)
  transform_response(response)
end

Contract Num, JsonString => JsonString
def handle_response(status, response)
  response
end
```

Si le code de la réponse HTTP est 200 on va transformer la réponse, sinon on se contentera de retourner la réponse.

## Conclusion

Les bénéfices sont nombreux. Les contrats nous permettent d'avoir une plus grande cohérence dans les entrées et les sorties. Le flux des données dans notre système est plus clair. Et la plupart des erreurs liées aux types dans notre système peuvent être corrigées rapidement et simplement. De plus ils permettent de rapidement comprendre ce que fait une méthode, ce qu'elle attend et ce qu'elle retourne, un peu comme de la documentation mais qui serait tout le temps à jour :p.
Je pense que l'on peut ainsi économiser pas mal de tests unitaires sur le type d'argument reçu par une méthode et se concentrer sur ce qu'elle produit avec ce système de contrats.

Voilà j'espère que cet article vous aura convaincu de l'utilité des contrats et du pattern-matching dans votre Ruby quotidien et vous donnera aussi l'envie d'explorer d'autres langages avec d'autres paradigmes.

# Qui a écrit cet article ?

{% img /images/julien.jpeg %}

**Julien Blanchard**  
M-x CTO RET Sush.io
