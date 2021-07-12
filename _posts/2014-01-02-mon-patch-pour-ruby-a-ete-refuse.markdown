---
layout: post
title: "Mon patch pour Ruby a été refusé"
date: 2014-01-02 18:53
legacy: true
tags: [ruby]
---



Il y a quelque jours, j'ai présenté les [nouvelles méthodes de la classe
Set](http://lkdjiin.github.io/blog/2013/12/30/ruby-2-dot-1-les-nouvelles-methodes-de-set/), mise à jour avec la sortie de Ruby 2.1.
Un commenteur m'a fait remarquer avec raison que le code pourrait être
bien plus simple. Ni une, ni deux, j'écris un patch, les tests passent,
j'envoie un pull request. Le patch sera gentillement refusé, et c'est
bien normal…

<!-- more -->

Voici le code des méthodes originales:

{% highlight ruby %}
  def intersect?(set)
    set.is_a?(Set) or raise ArgumentError, "value must be a set"
    if size < set.size
      any? { |o| set.include?(o) }
    else
      set.any? { |o| include?(o) }
    end
  end

  def disjoint?(set)
    !intersect?(set)
  end
{% endhighlight %}

Et voici comment je les ai recodées:

{% highlight ruby %}
  def intersect?(set)
    !disjoint?(self)
  end

  def disjoint?(set)
    set.is_a?(Set) or raise ArgumentError, "value must be a set"
    (self & set).empty?
  end
{% endhighlight %}

Je trouvais mon nouveau code vraiment très bien foutu: deux fois plus court et
plus simple à lire. Seulement j'avais oublié deux petites choses qui le rendent
moins efficace que le code original:

Premièrement, mon code crée un objet intermédiaire 
(avec `self & set`) qui n'est pas nécessaire.

Deuxièment, le code original s'arrête dès qu'un élément en commun est trouvé,
alors que le mien remplira un (nouveau) set avec tout les éléments en
communs. C'est évidemment beaucoup moins efficace, surtout avec de gros sets.

Moralité : un code plus court n'est pas toujours synonyme de plus efficace !



À demain.



