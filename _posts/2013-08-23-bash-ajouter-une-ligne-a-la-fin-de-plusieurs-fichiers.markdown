---
layout: post
title: "Bash: ajouter une ligne à la fin de plusieurs fichiers"
date: 2013-08-23 11:26
legacy: true
tags: [bash]
---



Dans l'article d'hier, je décrivais mon deuxième plugin pour Octopress.
Pour le mettre en place sur ce blog, je vais devoir ajouter une ligne de
texte à l'ensemble des articles. Il y en a presque une cinquantaine
maintenant, il est donc hors de question de le faire à la main.
Bash va me faire ça en quelques secondes.

<!-- more -->

J'ouvre une console dans le dossier où sont placés mes articles, et j'entre
ce qui suit:

{% highlight console %}
[~/.../source/_posts]⇒ for file in *.markdown; do
> echo 'ligne à ajouter' >> "$file"
> done
{% endhighlight %}

Tada ! C'est fini. Si vous n'êtes pas familier de Bash, voici une petite
description de ce qui s'est passé:

{% highlight bash %}
for file in *.markdown; do
# ...
done
{% endhighlight %}

`for - do - done` est une structure d'itération de Bash, en gros l'équivalent
d'une boucle `for` en C, Java, etc. On l'utilise généralement pour itérer
sur les arguments de la ligne de commande, ou bien, comme ici, sur les
fichiers du répertoire. Elle peut s'écrire aussi sur 3 lignes:

{% highlight bash %}
for x in *
do
ma_commande
done
{% endhighlight %}

Et même sur une seule ligne: `for x in *; do ma_commande ; done`

{% highlight bash %}
echo 'ligne à ajouter' >> "$file"
{% endhighlight %}

La commande `echo` affiche normalement une chaîne de caractère sur
la console. Ici cette chaîne est redirigée avec `>>` dans le fichier
représenté par `"$file"`.

`>>` permet d'ajouter en fin de fichier. et le `$` permet d'extraire le contenu
d'une variable.

Pour conclure
-------------
La syntaxe de Bash m'a toujours défrisé, mais quand il s'agit de traiter des
fichiers texte, c'est vraiment un outil puissant. Comme je suis curieux,
j'aimerais bien savoir ce que *toi*, lecteur, tu aurais utilisé pour
cette tâche. Bash, Perl, Sed, Awk, Ruby, autre chose ?





À demain.



