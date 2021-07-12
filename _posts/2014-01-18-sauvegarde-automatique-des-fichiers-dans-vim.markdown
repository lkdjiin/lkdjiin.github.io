---
layout: post
title: "Sauvegarde automatique des fichiers dans Vim"
date: 2014-01-18 09:45
legacy: true
tags: [vim, débutant]
---



Aujourd'hui je parle d'un petit truc qui me facilite
énormément la vie sous Vim: la sauvegarde automatique.

<!-- more -->

Grâce à ce truc, je n'enregistre pratiquement jamais
*intentionnellement* un fichier. Ce qui fait que je
n'oublie jamais de le faire. Vous savez ? : On modifie
un fichier, on lance l'appli et… arg… ça fonctionne pas !
Tout ça parce qu'on a oublié d'enregistrer les
modifications.

Donc pour enregistrer le fichier courant, la commande est:

{% highlight vim %}
:w
{% endhighlight %}

Pour enregistrer tous les fichiers:

{% highlight vim %}
:wall
{% endhighlight %}

Pour les accros du Ctrl-S, on peut le reproduire avec le mapping
suivant dans le `.vimrc`:

{% highlight vim %}
map <C-s> :w<Enter>
{% endhighlight %}

**Et maintenant le truc promis**. Je veux que mes fichiers soient enregistrés
quand un onglet perds le focus, ou quand Vim lui-même perds le focus:

{% highlight vim %}
autocmd FocusLost,TabLeave * :wall
{% endhighlight %}

Avec cette commande dans votre `.vimrc`, il est rare de devoir
enregistrer manuellement un fichier ;)

Et si vous voulez comprendre ce que fais exactement cette commande, je
vous laisse regarder l'aide:

{% highlight vim %}
:h autocmd
:h FocusLost
:h TabLeave
{% endhighlight %}



À demain.


