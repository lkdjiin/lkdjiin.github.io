---
layout: post
title: "Installer le langage Elixir"
date: 2013-07-21 08:56
legacy: true
tags: [elixir]
---


Ça fait quelques jours que j'essaie de faire des petits programmes avec
Elixir. J'entends parler de ce nouveau langage depuis plusieurs mois déjà, et
je n'avais pas encore eu le temps de m'amuser un peu avec. C'est chose
faite. Elixir est un langage dynamique, fonctionnel, concurrent, immuable
et on dit qu'il ressemble beaucoup à Ruby. C'est l'occasion pour moi de
débuter une série d'articles consacrés à Elixir. Ça commence aujourd'hui
avec l'installation.

<!-- more -->

*Je vais décrire l'installation pour Debian, mais ça ne semble pas être
bien différent sur d'autres OS.*

Installer d'abord Erlang
------------------------
Elixir est bati au-dessus du langage Erlang, il faut donc tout d'abord
installer le compilateur Erlang avant d'installer Elixir à proprement parler.
La version R16B minimum est requise.
La marche à suivre est indiqué sur la page
[download-erlang-otp](https://www.erlang-solutions.com/downloads/download-erlang-otp).
Pour résumer, on ajoute la ligne suivante au fichier `/etc/apt/sources.list`:

    deb http://binaries.erlang-solutions.com/debian squeeze contrib

Puis on installe la clé:

    wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc \ 
    | sudo apt-key add -

Après y-a-pu-ka:

    apt-get update
    apt-get install esl-erlang

On s'assure que l'installation est bien réalisée:

{% highlight bash %}
xavier:~$ erl
Erlang R16B01 (erts-5.10.2) [source-bdf5300] [smp:2:2] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V5.10.2  (abort with ^G)
1> 
{% endhighlight %}

Installer Elixir
----------------
Voilà Erlang est installé, c'est maintenant au tour d'Elixir proprement dit.
Pas de chance, il n'y a pas de package pour Debian, je dois donc installer
à partir des [sources](https://github.com/elixir-lang/elixir/tags). C'est
aussi simple que de décompresser l'archive et de taper `make`. À ce moment
là j'ai quand même un petit doute: pas de dépendances, de lib à installer ?
Mais je comprends vite que c'est Erlang qui est en train de compiler Elixir.
Donc non, tout va bien et ça marche du premier coup. Un petit truc quand
même, Elixir étant installé en local, il faut modifier la variable `PATH`
du shell pour pas galérer:

{% highlight bash %}
PATH=$PATH:/home/xavier/local/bin/elixir-0.9.3/bin/
{% endhighlight %}

Reste à voir si ça fonctionne vraiment:

{% highlight bash %}
xavier:~$ iex
Erlang R16B01 (erts-5.10.2) [source-bdf5300] [smp:2:2] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (0.9.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> 1+1
2
iex(2)>
{% endhighlight %}

Cool ! L'installation s'est déroulée à merveille, tout marche du premier
coup. C'est bon signe ou pas ?

Mise à jour d'Elixir
--------------------
Il sort pratiquement une nouvelle version d'Elixir par mois ; je sens
que les mises à jour vont faire partie de ma vie d'elixiriste (oui je
l'ai inventé celui-là, comment vous diriez ? Elixirien ?)
En fait, en
écrivant cet article, je m'aperçois que la version 0.10.0 est sortie.
C'est donc ma première mise à jour. Après le téléchargement,
la décompression et le `make`, il suffit d'accommoder le `PATH`:

{% highlight bash %}
PATH=$PATH:/home/xavier/local/bin/elixir-0.10.0/bin/
{% endhighlight %}

Et la nouvelle version est prête à l'emploi. Si Elixir est aussi sympa que son
installation, ça promet. Affaire à suivre.





À demain.


