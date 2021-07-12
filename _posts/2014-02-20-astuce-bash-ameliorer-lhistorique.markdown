---
layout: post
title: "Astuce Bash - Améliorer l'historique"
date: 2014-02-20 21:02
legacy: true
tags: [bash, débutant, astuce]
---



Dans Bash, chaque appui sur la touche «flêche vers le haut» fait défiler
l'historique des commandes. Si la commande recherchée se situe à quelques
dizaines d'appuis, ça n'est pas très pratique. Voici une astuce pour
aller plus vite.

<!-- more -->

Ajoutez les lignes suivantes dans votre fichier `~/.inputrc`. Si ce dernier
n'existe pas, créez le.

{% highlight bash %}
"\e[A": history-search-backward
"\e[B": history-search-forward
set show-all-if-ambiguous on
set completion-ignore-case on
{% endhighlight %}

Maintenant il suffit de saisir les premières lettres de la commande
recherchée et la flêche vers le haut ne fera défilée que les commandes
de votre historique qui commencent par ces caractères.

Quand j'aurais plus de temps, j'aimerais revenir sur ces lignes pour
fournir une explication, en attendant je vous souhaite une bonne
utilisation de votre historique boosté ;)



À demain.




