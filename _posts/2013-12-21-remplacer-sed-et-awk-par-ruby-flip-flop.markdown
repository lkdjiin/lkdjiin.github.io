---
layout: post
title: "Remplacer Sed et Awk par Ruby: Flip flop"
date: 2013-12-21 18:44
legacy: true
tags: [sed, awk, ruby]
---



Comment faire pour travailler sur un groupe de lignes, quand ce groupe
de lignes commence avec un marqueur et fini avec un autre ?
Par exemple, avec le fichier de données suivant, on cherche à afficher
les lignes depuis «start» jusqu'à «end»:

{% highlight raw %}
1
2
3
start
4
5
6
end
7
8
9
{% endhighlight %}

<!-- more -->

C'est ce qu'on appelle un *flip flop* : On commence le traitement sur une
condition de départ, puis on traite toutes les lignes jusqu'à une
condition d'arrêt. C'est un principe très utilisé avec Sed ou Awk.
Pour faire la même chose en Ruby, on va se servir d'un *range*:

{% highlight ruby %}
puts $_ if $_.start_with?("start")..$_.start_with?("end")
{% endhighlight %}

{% highlight bash %}
[~]⇒ ruby -n flip_flop.rb data.txt
start
4
5
6
end
{% endhighlight %}




À demain.



