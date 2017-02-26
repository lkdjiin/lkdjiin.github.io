---
layout: post
title: "Clojure, tests et couleurs"
date: 2017-02-26 10:53
comments: true
categories: [clojure, tdd, test, couleur]
---

En ce moment je regarde le langage Clojure de plus près.  J'utilise Leiningen
pour gérer les projets, et je voudrais maintenant utiliser la technique du
*Test Driven Development* pour faire quelques projets.

**Problème** : la sortie de `lein test` n'est pas en couleur. Quand on fait du TDD
avoir une sortie rouge en cas d'échec et verte en cas de succès est vraiment
confortable, ça évite d'avoir à lire. (*Notez que Fish m'indique indirectement
l'échec en colorant le `$` de mon prompt en rouge. C'est déjà ça, mais j'en
voudrais un peu plus.*)

J'ai donc cherché et trouvé [Ultra](https://github.com/venantius/ultra), un
plugin pour Leiningen. Il fait bien le boulot, et même plus.

**Nouveau problème** : Je passe de 3 secondes d'attente sans le plugin à 7 secondes
avec le plugin. Ce qui a évidemment tendance à *casser* le flot du TDD, pour le dire
gentiment.

```
$ time lein test
#...
Ran 1 tests containing 1 assertions.
#...

#=> Sans couleurs 2.76 secondes
#=> Avec couleurs 6.81 secondes
```

**D'où ma question pour ceux/celles qui savent : avez vous une solution pour avoir
une sortie couleur des tests *et à la fois* un temps de réponse acceptable ?**

{% connexe %}
