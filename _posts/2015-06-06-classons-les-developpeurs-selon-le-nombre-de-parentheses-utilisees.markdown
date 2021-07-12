---
layout: post
title: "Classons les développeurs selon le nombre de parenthèses utilisées"
date: 2015-06-06 10:25
legacy: true
tags: [humour, classement]
---

Depuis quelques mois je vois passer ici et là plusieurs «classements des
développeurs».  Plutôt que de dire ce que je pense de ces
classements, je voudrais en rire un peu en proposant une nouvelle méthode de
classification.

**Et si on se mettait à juger notre code par le nombre de parenthèses inutiles
qu'il produit ?**

<!-- more -->

Petite histoire inventée : *Un jour j'ai passé 3 heures à trouver un bug causé
par des parenthèses manquantes. Depuis, je m'assure que cela n'arrivera plus
jamais, quitte à ce que personne (pas même moi d'ailleurs) puisse me relire.*

En R par exemple :

{% highlight r %}
# Quand j'ai décidé que je réfléchirai demain.
data[((data$var1 < 3) & (data$var2 > 11)), ]

# Quand je suis en forme, mais pas trop quand même.
data[(data$var1 < 3 & data$var2 > 11), ]

# Bon, là, ça va.
data[data$var1 < 3 & data$var2 > 11, ]
{% endhighlight %}

À plus tard pour un article plus sérieux ;) Peut-être sur la
précédence des opérateurs ?!
