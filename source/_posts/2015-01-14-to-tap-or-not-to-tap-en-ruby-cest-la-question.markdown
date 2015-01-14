---
layout: post
title: "To tap or not to tap en Ruby ? C'est la question"
date: 2015-01-14 20:59
comments: true
categories: [ruby]
---

{% level 1 %}

Le monde des Rubyistes est divisé en deux: ceux qui utilisent `Object#tap` à tout
propos, et ceux qui ne connaissent pas cette méthode.
Dans l'article [Five Ruby Methods You Should Be Using](https://blog.engineyard.com/2015/five-ruby-methods-you-should-be-using)
sur le blog d'Engine Yard, Ben Lewis nous parle justement, entre autre, de `Object#tap`
en expliquant très bien son mécanisme.

Mon article d'aujourd'hui sera lui aussi divisé en deux, d'abord une traduction en
français de l'article original de Ben Lewis sur `Object#tap`, puis une critique
(que j'espère constructive)
à la fois de l'article et de la méthode `tap`

<!-- more -->

### Traduction de l'article original Object#tap

Vous êtes vous déjà trouvé dans la situation d'appeler une méthode sur un
objet, et que la valeur de retour ne soit pas ce que vous vouliez ? Vous
espériez recevoir l'objet en question, mais à la place vous avez reçu une autre
valeur. Peut-être que vous vouliez ajouter une valeur arbitraire à un ensemble
de paramètres enregistrés dans un hash. Vous mettez à jour cette valeur avec
`Hash.[]`, mais vous recevez `'bar'` au lieu de l'objet hash `params`, donc vous
devez le renvoyer explicitement.

``` ruby
def update_params(params)
  params[:foo] = 'bar'
  params
end
```

La ligne qui contient `params` à la fin de cette méthode semble être de trop.

On peut arranger ça avec `Object#tap`.

C'est facile à utiliser. Appeler simplement `tap` sur l'objet, puis passer à
`tap` un bloc avec le code que vous voulez lancer sur cet objet. L'objet sera
donné au bloc, puis retourné. Voici comment nous pouvons l'utiliser pour
améliorer `update_params`:

``` ruby
def update_params(params)
  params.tap {|p| p[:foo] = 'bar' }
end
```

Il y a des douzaines d'excellents endroits où utiliser `Object#tap`. Cherchez
simplement les méthodes appelées sur un objet qui ne renvoient pas l'objet
lui-même, alors que c'est ce que vous voudriez.


### Fin de la traduction et début de la critique

L'article explique très bien la mécanique de `Object#tap`, sur ce point pas de souci.
Mais j'ai un problème avec l'exemple choisi, que je trouve peu adapté.
— _Pour être tout à fait honnête, j'ai plutôt un problème avec `tap`._ —
Si on rapproche les deux versions,
je trouve que la première est beaucoup plus facile à lire. Même si celle-ci
comporte une ligne de plus. Même si cette ligne supplémentaire ne fait *pas
très pro*:

``` ruby
def update_params(params)
  params[:foo] = 'bar'
  params
end
```

``` ruby
def update_params(params)
  params.tap {|p| p[:foo] = 'bar' }
end
```

Dans la première version, voici comment se passe la lecture dans ma tête:

_«Dans l'objet `params` on enregistre la clé `:foo` avec la valeur `'bar'` puis on
renvoie `params`»_

C'est cristallin, précis, simple, rapide.

Dans la seconde version, ça donne ceci (toujours dans ma tête, hein):

_«On se branche sur l'objet `params`, donc il sera renvoyé à la fin de la méthode.
Dans le bloc on utilise `p`, qui est… ? … qui est `params`, ok, donc on enregistre
la clé `:foo` avec la valeur `'bar'` dans `params`.»_

C'est loin d'être aussi fluide. Y a plein de parasites. Ce qui fait que dans ce
cas précis, je préfere très nettement la première version.

Au passage, je trouve que `p` est très mal choisi, ça me donne la fausse sensation que le
bloc va itérer sur chaque paramètre. Selon moi il n'y a aucune raison pour ne pas
réutiliser `params`, bien au contraire:

``` ruby
def update_params(params)
  params.tap {|params| params[:foo] = 'bar' }
end
```

Là où `tap` peut améliorer légèrement la lecture, c'est lorsqu'il y a beaucoup
d'opérations sur un objet:

``` ruby
def create_an_item(params)
  item = Item.new(params)
  item.do_something
  item.do_another_thing
  item.send_email_confirmation_to_admin
  item.do_something_else
  item.important_stuff
  item.less_important_stuff_to_do
  item
end
```

On n'y comprend rien, hein ?  Avec `tap`, ça permet de voir rapidement que ce
code ne comporte rien d'autre que des opérations sur un *item*:

``` ruby
def create_an_item(params)
  Item.new(params).tap do |item|
    item.do_something
    item.do_another_thing
    item.send_email_confirmation_to_admin
    item.do_something_else
    item.important_stuff
    item.less_important_stuff_to_do
  end
end
```

Mais encore une fois, l'amélioration apportée est légère. Et elle est
seulement visuelle. Je vois régulièrement ce genre de code et je ne l'aime pas.
`Item.new.tap`, par exemple, c'est la [loi de Démeter](http://en.wikipedia.org/wiki/Law_of_Demeter) qu'on foule du pied.
Et le code à l'intérieur du bloc reste une bouillie qu'on ferait mieux
de refactorer.

Bref, la méthode `Object#tap` me semble poser plus de problèmes qu'elle n'en
résout. Vous avez un avis sur le sujet ?

{% connexe %}
