---
layout: post
title: "Les algorithmes génétiques démystifiés 8 - Le paradoxe du singe savant"
date: 2013-09-08 09:40
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Dans son livre [The nature of code](http://natureofcode.com/),
Daniel Shiffman consacre un chapitre aux algorithmes génétiques. Je lui
pique l'idée du prochain algorithme que je vais développer sur ce blog.

Cette fois j'aimerais vous montrer un algorithme génétique plus traditionnel,
dans l'esprit de la *méthode* développée par
[John Holland](http://en.wikipedia.org/wiki/John_Henry_Holland), qu'on peut
considerer comme le pionnier en la matière.

<!-- more -->

Objectif
--------
Le but du jeu est d'obtenir la phrase suivante : «Mon royaume pour un
cheval». C'est une variante du
[paradoxe du singe savant](http://fr.wikipedia.org/wiki/Paradoxe_du_singe_savant).
Contrairement à [l'algorithme précédent](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/), les chromosomes vont
être représentés par une simple phrase, et non par une chaîne de bits.
Cela va me permettre de me concentrer plus sur l'explication de la
méthode de sélection. Le programme sera encore écrit en Ruby, dans un
style procédural, pour permettre au plus grand nombre de le comprendre
facilement. La seule différence avec le style de code de
[l'algorithme précédent](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/) est que je vais éviter les *nombres magiques*
pour pouvoir plus simplement personnalisé l'algorithme.

L'intérêt d'un problème aussi simple, et dont on connait déjà la solution,
est d'apprendre à avoir confiance dans les algorithmes génétiques.
Lorsqu'on passera plus tard à la résolution d'un problème inconnu, on n'aura
pas à se demander «est-ce-que ça fonctionne vraiment ?».

Créer la population
-------------------

Voici le code qui va permettre de créer la population de solutions
potentielles:

``` ruby monkey.rb
def make_chromosome
  value = ""
  length = @search_value.size
  length.times { value += random_gene }
  [nil, value]
end

def random_gene
  @genes[rand(@genes.size)]
end

def make_population
  population = []
  @population_size.times { population << make_chromosome }
  population
end

@search_value = "Mon royaume pour un cheval"
@genes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
@population_size = 100
@population = make_population
@population.each {|i| puts i.inspect }
```

La fonction `make_chromosome` crée une phrase de la même taille que celle qu'on
recherche. Elle se sert de la fonction `random_gene` pour obtenir les gènes
au hasard. Un gène, ici, est une lettre minuscule ou majuscule, ou un espace.
`make_chromosome` renvoie une liste avec la phrase et une valeur nulle placée
au début. Cette valeur nulle sera remplacée plus tard par l'évaluation
de la phrase.

Voilà ce que donne le programme pour l'instant:

    [~/genetic]⇒ ruby monkey.rb 
    [nil, "OdjBvCjnhCGRukFKwbpnUbSGzR"]
    [nil, "uVqkznTRQwbUkrxUklkWgIVfyv"]
    [nil, "LIRrECVrjFZPqaoySxosMs hdX"]
    [nil, "XghuLIEopQNUjECpnnhtISelLs"]
    [nil, "ovkilBZhnFTMEweTDOjsDbcqXX"]
    [nil, "tGkEbfscRscqqRfoCxtwPuRqVx"]
    [nil, "FHnwlsnoHtHbXTzsJohbyaxjIb"]
    [nil, "xNbSYbkULcgfootEBJwfYiZqrC"]
    [nil, "RcQfonEVMQnbdZX k glNDphbB"]
    .
    .
    .
    [nil, "OZVyLLOkKbzZnYTTLNxGty NWh"]
    [nil, "rPyGwpTjvUmblwXCqlYBUBtPmZ"]
    [nil, "FSQPGCFqYMWhaEurBOnefJceoZ"]
    [nil, "bsMFghPtlFfkYLpKWRohhSAHjY"]
    [nil, "FFATOumGCSfviwnzobeZOaIOJx"]
    [nil, "svVsIjmbuOBTxhfNCUgBrtoI j"]
    [nil, "ZyIqsyTefpdTmqxLzSDDPrMxQf"]
    [nil, "nbpmNBYOYcmEGI jbs RxocKzv"]
    [nil, "FlsryVrgyaGiciJBUzOfJameCh"]

Dans le prochain article, on s'occupera d'évaluer cette population de
phrase.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

