---
layout: post
title: "Ruby: un exemple de valeur par défaut pour un Hash"
date: 2013-10-03 10:52
legacy: true
tags: [ruby]
---



J'oublie régulièrement qu'un Hash peut renvoyer une valeur par défaut.
Du coup, je me retrouve souvent avec un code inutilement lourd.
Aujourd'hui je montre un exemple d'initialisation d'un Hash avec une
valeur par défaut et pourquoi c'est intéressant.

<!-- more -->

Dans [l'article d'hier](http://lkdjiin.github.io/blog/2013/10/02/les-algorithmes-genetiques-demystifies-27/)
(sur les algorithmes génétiques) je donnais un script de trois lignes sans
fournir d'explications, les voici.

L'objectif
----------

J'ai un fichier ("mots.txt") contenant un certain nombre de mots pouvant
apparaitre plusieurs fois:

    casserole
    casserole
    assiette
    fourchette
    casserole
    fourchette
    verre
    ...

Je veux connaitre le nombre d'occurence de chaque mot et produire une sortie
de ce genre:

    187 => casserole
     13 => assiette
      2 => fourchette
      1 => verre

La classe Hash expliquée en 30 secondes
--------------

*Si vous savez déjà ce qu'est un hash, passez directement à la section
suivante.*

Un *hash* peut contenir un nombre indeterminé de paires d'objets ; ces paires
étants organisées en clé/valeur. Ça marche comme un dictionnaire. Dans
d'autres langages, vous les connaissez peut-être sous le nom de dict, map,
tableau associatif, hashtable, etc. En Ruby, on peut créer un hash vide de
deux façons:

{% highlight ruby %}
hash = {}
autre_hash = Hash.new
{% endhighlight %}

On peut créer et remplir un hash en même temps:

{% highlight ruby %}
hash = { "clef1" => 123, "clef2" => 456 }
{% endhighlight %}

Pour connaitre la valeur associée à la clé "clef1":

{% highlight ruby %}
hash["clef1"]
{% endhighlight %}

Pour modifier la valeur associée à la clé "clef1":

{% highlight ruby %}
hash["clef1"] = 0
{% endhighlight %}

Pour ajouter une paire clé/valeur:

{% highlight ruby %}
hash["nouvelle clef"] = 123546789
{% endhighlight %}

Notez que les clés et leurs valeurs peuvent être de n'importe quel type.
On n'est pas limité à des chaînes de caractères et des nombres.

Première version
----------------

Mon premier jet a donné ceci:

{% highlight ruby %}
# Version 1

hash = Hash.new

File.open("mots.txt", "r").each_line do |line|
  if hash.key?(line)
    hash[line] = hash[line] + 1
  else
    hash[line] = 1
  end
end

hash.each {|key, value| puts "#{"%3d" % value} => #{key}" }
{% endhighlight %}

La première ligne crée un hash vide tandis que la dernière affiche
le contenu du hash, formaté comme je le veux. Au milieu, on itère sur
les lignes du fichier texte (les mots) pour remplir le hash,
c'est ça qui m'intéresse:

{% highlight ruby %}
  if hash.key?(line)
    hash[line] = hash[line] + 1
  else
    hash[line] = 1
  end
{% endhighlight %}

C'est une construction classique à base de if/else. Si le hash possède
une clé identique à la ligne en cours (`if hash.key?(line)`) alors on
incrémente sa valeur associée. Sinon on crée cette clé, associée à la
valeur 1 puisque c'est la première fois qu'on rencontre ce mot
(`hash[line] = 1`).

Deuxième version
-----------------

Ruby possède un opérateur ternaire (*ternary operator*) qui peut remplacer
un if/else simple comme le notre:

    condition ? oui : non

Si `condition` est vérifiée, on execute `oui`, sinon on execute `non`.
Dans notre cas on peut donc écrire:

{% highlight ruby %}
File.open("mots.txt", "r").each_line do |line|
  hash[line] = hash.key?(line) ? hash[line] + 1 : 1
end
{% endhighlight %}

Certains adorent ce genre de construction, d'autres détestent. *À priori* je
n'ai rien contre, mais il faut avouer que dans ce cas précis c'est tout
simplement illisible.

Troisième version
-----------------

Ruby possède un opérateur sympa qu'on peut parfois utiliser quand on veut
initialiser une variable si elle n'existe pas où la modifier si elle
existe: `||=`. Il faut savoir qu'un hash renvoie la valeur `nil` quand on
lui fournit une clé inexistante:

{% highlight ruby %}
File.open("result.txt", "r").each_line do |line|
  hash[line] ||= 0
  hash[line] += 1
end
{% endhighlight %}

`hash[line] ||= 0` va créer la clé et lui donner la valeur 0 si cette clé
n'existe pas, sinon la clé se voit affecter sa valeur. Ensuite la valeur de
la clé est incrémentée avec `hash[line] += 1`. Je trouve cela plus lisible
que la version avec l'opérateur ternaire, mais moins lisible que la version
avec le if/else, car cela fait appel à un «truc».

Quatrième et dernière version
-----------------------------

Voici la *bonne* version (selon moi bien entendu). Il faut modifier
légerement la création du hash:

{% highlight ruby %}
hash = Hash.new(0)
File.open("result.txt", "r").each_line do |line|
  hash[line] += 1
end
{% endhighlight %}

Quand vous créer un hash, vous pouvez lui dire: «Je veux que tu renvois
telle valeur quand on te donne une clé inexistante». Dans notre cas, les
clés inexistantes renverront toujours zéro. Le tour est joué: une simple
incrémentation suffit maintenant, qu'une clé existe déjà ou non.





À demain.



