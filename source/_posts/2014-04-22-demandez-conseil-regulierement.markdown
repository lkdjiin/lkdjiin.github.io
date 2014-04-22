---
layout: post
title: "Demandez conseil régulièrement"
date: 2014-04-22 21:43
comments: true
categories: [ruby, refactoring, débutant, truc]
---
{% level 1 %}

Aujourd'hui je réparais un bug, rien de très compliqué, juste un
évènement qui n'était pas appelé. Et j'en ai profité pour faire un
refactoring: passer d'une grosse méthode de classe à quelque chose de
plus construit.

<!-- more -->

En gros on avait cette structure:

``` ruby
module Machin
  class Truc
    def self.foo(des, arguments)
      # Plusieurs
      # lignes
      # d'initialisation
      # de variables.
      # Plusieurs
      # lignes
      # de calculs
      # divers.
      # Et j'en passe
      # ...
    end
  end
end
```

J'ai fait un refactoring dans ce genre:

```
module Machin
  class Truc
    def self.foo
      implementation = TrucImplementation.new(des, arguments)
      implementation.fait_ce_que_tu_as_a_faire
    end

    class TrucImplementation
      def initialize(des, arguments)
        # Initialisation.
      end

      def fait_ce_que_tu_as_a_faire
        # Ceci.
        # Cela.
      end

      private

      def ceci
        # ...
      end

      def cela
        # ...
      end
    end
  end
end
```

Mais j'étais vraiment ennuyé avec ce nom `TrucImplementation`. Je trouvais
que ça ne faisait pas très Ruby. Bref j'avais un sentiment bizarre sur ce
code donc j'ai demandé aux collègues une revue de code en disant que
j'aimerais bien nommé ça autrement…

La réponse n'a pas tardée, simple et sybilline: «Tu passes juste les méthodes de
`TrucImplementation` dans `Truc` et plus de soucis».

Pourquoi je raconte ça ? Pour me rappeler que parfois, avoir le nez dans le
code trop longtemps fait que tu ne vois plus ce qui est évident. Il ne faut
pas hésiter à demander un coup de main ; un point de vue différent, ou juste
plus frais, peut vite faire une différence.

Je pense que je n'ai pas fini d'être chambré là-dessus ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

