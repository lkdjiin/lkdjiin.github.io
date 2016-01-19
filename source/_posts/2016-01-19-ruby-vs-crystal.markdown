---
layout: post
title: "Ruby vs Crystal"
date: 2016-01-19 09:23
comments: true
categories: [ruby, crystal, benchmark]
---

Après avoir produit [quelques variations](/blog/2016/01/18/les-arbres-browniens-2eme-partie/) sur le thème des 
[arbres browniens](/blog/2016/01/17/les-arbres-browniens/) le
week end dernier, le moment semblait idéal pour tester le langage
[Crystal](http://crystal-lang.org/).

J'ai donc réécrit le programme de base que j'avais fait pour produire des
arbres browniens, en supprimant l'UI et en enregistrant (à la place d'une
image écran)
un fichier image
*— au format XPM, peut-être le sujet d'un prochain article —*.

Je calcule le temps que prends la construction de l'image, sans son
enregistrement:

{% img center /images/bench-crystal.png %}

<!-- more -->

Les deux programmes sont quasiment identiques, la version Crystal est
l'adaption au plus près de la version Ruby. Pour ce
programme particulier, Crystal est de 3 à 7 fois plus rapide que Ruby.

Je suis deçu car j'attendais mieux que ça. On m'avait vendu Crystal comme étant
plus rapide. En fait environ 20 fois plus rapide que Ruby.

Et c'est vrai qu'avec un petit truc comme ça:

```ruby
def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end
puts fibonacci 40
```

ou alors encore ça:

```ruby
x = 0
50_000_000.times do
  x += rand(11) - 5
end
```

j'obtiens bien un programme Crystal 20 à 35 fois plus rapide que sa version
Ruby. Mais avec un programme plus «réel», c'est 3 à 7. Alors je ne boude pas,
hein, même un gain de 3 est toujours bon à prendre. Par contre, passer de Ruby à
Crystal a un coût, et savoir si ce coût justifie un si petit gain est une autre
histoire.

La prochaine fois j'espère vous donner mes premières impressions sur Crystal.

{% connexe %}
