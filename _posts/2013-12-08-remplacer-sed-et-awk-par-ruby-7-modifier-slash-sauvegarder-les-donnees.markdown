---
layout: post
title: "Remplacer Sed et Awk par Ruby 7: Modifier/sauvegarder les données"
date: 2013-12-08 19:30
legacy: true
tags: [sed, awk, ruby]
---



Parfois on veut analyser un fichier, et parfois on veut le modifier.
Si on suit la logique de [cette série d'articles](http://lkdjiin.github.io/blog/2013/11/29/remplacer-sed-et-awk-par-ruby/), Ruby devrait offrir
un switch permettant de modifier un fichier sans avoir à l'enregistrer
explicitement. Et je ne vais pas vous surprendre
en vous apprenant qu'un tel switch existe, il s'agit de l'option
`-i`, qui permet aussi de sauvegarder l'ancien fichier.

<!-- more -->

L'exemple d'aujourd'hui est encore plus trivial que d'habitude ;) Voici
le fichier de données:

{% highlight raw %}
alice
bob
{% endhighlight %}

Ce que je voudrais, c'est simplement tout mettre en majuscule. Ce que
permet le script suivant:

{% highlight ruby %}
$_.upcase!
{% endhighlight %}

Si on lance le script comme on sait le faire maintenant
(voir par exemple [l'article précédant](http://lkdjiin.github.io/blog/2013/12/07/remplacer-sed-et-awk-par-ruby-6-separateur-de-champ/)), on obtient un bel
affichage:

    [~/test]⇒ ruby -p test.rb data.txt 
    ALICE
    BOB

Mais le fichier lui-même n'a pas changé:

    [~/test]⇒ cat data.txt
    alice
    bob

Si on veut modifier le fichier, on doit se servir de l'option `-i` en
spécifiant l'extension qui sera ajouter au fichier original sauvegardé,
ici `.2`:

    [~/test]⇒ ruby -p -i.2 test.rb data.txt 

Et voilà, on a bien les deux fichiers attendus:

    [~/test]⇒ ls data*
    data.txt  data.txt.2

Notre fichier est bien modifié:

    [~/test]⇒ cat data.txt
    ALICE
    BOB

Et il est bien sauvegardé:

    [~/test]⇒ cat data.txt.2
    alice
    bob





À demain.



