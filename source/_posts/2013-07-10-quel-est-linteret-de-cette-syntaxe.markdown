---
layout: post
title: "Quel est l'intérêt de cette syntaxe ?"
date: 2013-07-10 09:04
comments: true
categories: [ruby, code propre]
---

En googlant sur `ruby design pattern factory` je suis tombé sur un
[post intéressant]( http://blog.rubybestpractices.com/posts/gregory/059-issue-25-creational-design-patterns.html).
Non, je ne vais pas vous parler de design pattern dans cet article. L'exemple
qui m'a plus particulierment intrigué est le suivant:

``` ruby Exemple original
class AdjacencyMatrix  
  class << self  
    def undirected(data)  
      new(data)  
    end  
  
    def directed(data)  
      new(data,true)  
    end  
  
    private :new  
  end  
  
  def initialize(data, directed=false)  
    #...  
  end  
end  
  
undirected_matrix = AdjacencyMatrix.undirected(data)   
directed_matrix   = AdjacencyMatrix.directed(data)
```

Pourquoi cet exemple m'a intrigué ? Pas parce qu'il parle de matrice, je vous
rassure. Je ne comprends pas grand chose aux matrices, et je n'ai jamais
entendu parler d'«adjacency matrix». Si cet exemple m'intrigue, c'est parce que
je ne comprends pas, _à priori_, l'intérêt du `class << self`.  Il me semble
que je peux réécrire ça sans `class << self` et que le résultat serait le même.

<!-- more -->

Alors allons y. Voilà le nouveau bout de code qui fait la même chose que
le précédent:

``` ruby Seconde version
class AdjacencyMatrix  
  def self.undirected(data)  
    new(data)  
  end  

  def self.directed(data)  
    new(data,true)  
  end  

  private_class_method :new
  
  def initializedata, directed=false)  
    #...  
  end
end  
  
undirected_matrix = AdjacencyMatrix.undirected(data)
directed_matrix   = AdjacencyMatrix.directed(data)
```

{% pullquote %}
L'API et le résultat sont identiques. Alors c'est pas nouveau, avec Ruby il y a
toujours deux (ou trois, ou plus) manières différentes de faire la même chose.
Mais là, je me demande plus particulièrment si il y a un **intérêt** à utiliser
la syntaxe du premier exemple. Et je ne vois pas.  Du coup il me vient une
seconde question : entre ces deux exemples, quel est le meilleur code ? Et part
_meilleur_, j'entends bien sûr _le plus lisible_.  
Sans vous faire attendre plus
longtemps, je pense que le second exemple possède le code le plus lisible.
Pourquoi ? Parce qu'il est plus simple ? Non, parce que ça n'est pas forcement
très pertinent dans ce cas précis.
Même si je pense que 9 fois sur 10 {" un code plus simple est un code plus
maintenable, "} je dois reconnaitre que quelqu'un d'habitué à manipuler du code
Ruby comprendra aussi facilement et rapidement les deux syntaxes précédentes.
{% endpullquote %}

{% pullquote %}
En fait, si le second
exemple me parait plus lisible, c'est parce qu'il possède un niveau
d'indentation du code en moins. Plus on est proche de la marge gauche, et plus
le code se lit aisément. C'est pas toujours évident à voir
sur des exemples aussi courts, c'est vrai. Mais quand on lit du code, comme
celui de l'exemple 1, étalé sur une centaine de lignes ou plus, il est facile
de se perdre et/ou d'oublier si on a affaire à une méthode de classe ou à une
méthode d'objet.
Un code devrait pouvoir se lire comme une histoire. Pour pousser la logique,
{" je voudrais lire du code aussi facilement et naturellement que je lis
un livre "}. Et dans un
livre, les lignes débutent à la marge gauche. Voilà pourquoi je préfère le
code du second exemple.
{% endpullquote %}

Quel est l'intérêt de `class << self` ?
---------------------------------------

Quoi qu'il en soit, je n'ai toujours pas de réponse à ma première question:
«quel est l'intérêt de `class << self`» dans cet exemple précis.
Il est possible que dans une ancienne
version de Ruby, il n'y avait pas moyen de faire autrement et qu'on ai gardé
l'habitude ? Peut-être qu'il n'y a aucune réponse ? Je vais donc aller faire un
tour du coté de la divinité StackOverflow pour tenter d'y voir plus clair. Je
vous tient au courant dans un futur article si je trouve quelque chose.

À demain.

