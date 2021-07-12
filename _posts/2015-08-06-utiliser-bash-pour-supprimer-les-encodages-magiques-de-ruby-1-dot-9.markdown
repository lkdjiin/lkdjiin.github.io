---
layout: post
title: "Utiliser Bash pour supprimer les encodages magiques de Ruby 1.9"
date: 2015-08-06 17:27
legacy: true
tags: [ruby, encodage, bash, sed]
---

Si vous avez travaillé sur des projets écrit avec Ruby 1.9, vous avez peut-être
utilisé les encodages magiques (souvent appelés *magic comment*). Il s'agit
d'un commentaire en début de fichier qui définit l'encodage&nbsp;:

{% highlight ruby %}
# -*- encoding: UTF-8 -*-
{% endhighlight %}

Récemment j'ai passé plusieurs projets de Ruby 1.9.x à Ruby 2.x et j'ai
naturellement voulu supprimer ces *directives d'encodage* qui ne sont plus
nécessaires.

J'imagine qu'un IDE ou un autre doit être capable de faire ça (`<mode troll>`
sinon quel intérêt à utiliser un IDE ? `</mode troll>`). Toujours est-il que
quelques commandes dans Bash et hop, terminé ;)

Voici comment faire, sans trop entrer dans les détails. J'espère juste vous
donner envie d'utiliser Bash, ou un autre shell (si ça n'est pas déjà le cas).

<!-- more -->

De quoi a-t-on besoin ?  `find`, `sed` et `xargs` :

{% highlight bash %}
$ find . -type f -name '*.rb' | xargs sed -i '1{/encoding/d}'
$ find . -type f -name '*.rb' | xargs sed -i -n '/./,$p'
{% endhighlight %}

La première commande efface la première ligne des fichiers ruby si cette
ligne contient `encoding`. La seconde commande enlève la première ligne si
cette ligne est vide.

## find

    find . -type f -name '*.rb'

Cherche tout les fichiers dont le nom se termine par `.rb` et les affichent
les uns après les autres.  Ça donne quelque chose comme ça :

    ./fichier1.rb
    ./fichier2.rb
    ./dossier1/fichier1.rb
    ./dossier1/fichier2.rb
    ./dossier2/fichier1.rb
    [...]

## xargs

Pour donner les noms de fichier à manger à sed, il faut qu'ils soient sur une
seule ligne. C'est à dire les uns à coté des autres comme on écrirait des
paramètres, et pas les uns en dessous des autres comme ce qui sort de `find`.

Voilà donc `xargs` :

{% highlight bash %}
$ echo -e "a\nb\nc"
a
b
c
$ echo -e "a\nb\nc" | xargs
a b c
{% endhighlight %}

– *Le switch `-e` de echo interprète la séquence \n comme un saut de ligne.* —

## sed

Le switch `-i` c'est pour *in place*. On modifie vraiment les fichiers.

    sed -i '1{/encoding/d}'

Supprime (`d`) la ligne qui contient `encoding`. Ne s'applique qu'à la 1ère
ligne `1{}`.

    sed -i -n '/./,$p'

Supprime la 1ère ligne si elle est vide. Je trouve que cette ligne mérite bien
un article à elle toute seule. Alors son explication sera pour une prochaine
fois ;)

Et vous, comment auriez vous fait ? Avec un shell ? Un IDE ?
