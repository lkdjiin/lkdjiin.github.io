---
layout: post
title: "Ruby vs Crystal - 2ème partie"
date: 2016-01-19 13:58
comments: true
categories: [crystal, ruby]
---


J'ai testé le langage Crystal le week end dernier. Rien de très poussé, juste
140 lignes de Ruby traduites en Crystal et [un benchmark](/blog/2016/01/19/ruby-vs-crystal/). Je vais tenté de
synthétiser mes premières impressions sur ce langage.

Dans cet article
mon point de vue est celui d'un développeur Ruby qui cherche à rendre
ses programmes plus rapide avec l'aide de Crystal.

## Crystal n'est pas Ruby

Si je devais retenir une seule chose, ce serait celle-ci: **Crystal n'est pas un
Ruby compilé**.  Si sa syntaxe ressemble beaucoup à celle de Ruby,
c'est vraiment un langage différent. La plus grande différence étant qu'il est
statiquement typé.

<!-- more -->

## Pas de REPL

Les développeurs de Crystal ont l'air de penser que c'est compliqué de lui
ajouter un REPL, et ça l'est sûrement. Ne pas avoir accès à un REPL n'est pas
rédhibitoire pour un langage statique. Mais cela implique un processus de
développement totalement différent de celui de Ruby et des langages dynamiques,
même si le compilateur semble pour l'instant assez rapide.

## Plusieurs méthodes sont absentes

Ou bien elles fonctionnent différemment. Il n'y a pas de `require_relative`, par
exemple:

```ruby
# crystal
require "./xpm"
# De plus le fichier doit être nommé `xpm.cr`

# ruby
require_relative "xpm"
```

Bien plus surprenant, il n'y a pas de `attr_reader`, il faut définir la méthode.
Peut-être que les développeurs n'ont pas encore eu le temps de s'y atteler ?

```ruby
# crystal
def foobar
  @foobar
end

# ruby
attr_reader :foobar
```

## Pas de private «global»

Avec Crystal, on définit une méthode privée au coup par coup.
C'est une syntaxe qui est possible en Ruby depuis la version 2 (2.1 je crois),
mais qui n'a jamais *pris*.

```ruby
# crystal
private def foo(a, b)
  a + b
end
```

## Typage statique

Est-ce que j'ai déjà mentionné que Crystal est un langage statiquement typé ?
Oui ?
Il est donc très <strike>gonflant</strike> tatillon avec les types.

```ruby
# crystal
"%i" % 1.0   #=> erreur !

# ruby
"%i" % 1.0   #=> "1"
```

## L'inférence de types

L'inférence de types, c'est bien, non ? Ça permet au compilateur de *deviner* le
type d'une variable pour que nous n'ayons pas à les spécifier nous même. Sauf
que dans l'optique d'une traduction d'un programme Ruby en Crystal je ne suis
pas convaincu du truc. Si on écrit un programme Crystal *from scratch*, pas de
soucis. Mais Ruby est bourré d'idiomes et de tics en tout genres qui vont
rendre le portage pas du tout trivial, à mon avis. Par exemple le code ruby
suivant initialise le tableau `@free_cells`:

```ruby
# ruby
def initialize
  @free_cells = Array.new(FREE_TOTAL) do
    [rand(SIZE), rand(SIZE)]
  end
end
```

Puis, dans la méthode `move`, les éléments de ce tableau sont modifiés. Il est
possible que certains éléments soient mis à `nil`. Mais comme vous pouvez le
voir à la fin de la méthode, avant de *relacher le tableau dans la nature*,
les éléments `nil` sont supprimés. C'est pour moi un cas d'utilisation
légitime de `nil`:

```ruby
# ruby
def move
  # [...]
  @free_cells.map! do |cell|
    # Modification des éléments, certains peuvent devenir nil.
  end

  @free_cells.compact!
end
```

Mais un compilateur n'avalera pas cette belle histoire. Le tableau a été
initialisé avec un certain type et vous ne pourrez donc pas en utiliser
d'autres. Vous devrez dire à Crystal quels types peut contenir le tableau,
c'est une syntaxe spécifique à Crystal, inconnue de Ruby:

```ruby
# crystal
def initialize
    @free_cells = [] of Array(Int32) | Nil
    FREE_TOTAL.times { @free_cells << [rand(@size), rand(@size)] }
end
```

Mais si maintenant je peux insérer des `nil` dans mon tableau, plus question de
pouvoir lire ses éléments ainsi:

```ruby
@free_cells.map! do |cell|
  cell[0]
```

Et non ! Puisque `@free_cells` a été déclaré comme pouvant contenir `nil` !
Même si **je sais** qu'à ce moment le tableau est exempt de `nil`, le
compilateur, lui, ne peut pas le savoir.
Il faut donc faire quelque chose comme ça:

```ruby
@free_cells.map! do |cell|
  if cell.is_a?(Array)
    cell[0]
  else
    # ...
```

Ou bien il faut repenser différemment le code. Et on commence a bien sentir
l'influence du typage statique, hein ? Encore une fois, ça n'est pas un
problème en soi, mais ça n'est pas Ruby.

## Conclusion

Si on a de l'expérience avec les langages à typage statique, traduire un
programme Ruby en un programme Crystal n'est pas difficile et le gain de
performance peut-être intéressant.
Dans tout les cas, **Crystal n'est pas Ruby**. Travailler avec ce langage sera
différent et demandera des processus différents.
Reste à savoir quels programmes Ruby on va pouvoir réécrire en Crystal sans
avoir à réécrire, au hasard, tout ActiveRecord. Et là, je ne suis pas certain
qu'on va en trouver beaucoup.

{% connexe %}
