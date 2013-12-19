---
layout: post
title: "Bash: ajouter une ligne à la fin de plusieurs fichiers"
date: 2013-08-23 11:26
comments: true
categories: [bash, script, débutant]
---

{% level 1 %}

Dans l'article d'hier, je décrivais mon deuxième plugin pour Octopress.
Pour le mettre en place sur ce blog, je vais devoir ajouter une ligne de
texte à l'ensemble des articles. Il y en a presque une cinquantaine
maintenant, il est donc hors de question de le faire à la main.
Bash va me faire ça en quelques secondes.

<!-- more -->

J'ouvre une console dans le dossier où sont placés mes articles, et j'entre
ce qui suit:

``` console
[~/.../source/_posts]⇒ for file in *.markdown; do
> echo 'ligne à ajouter' >> "$file"
> done
```

Tada ! C'est fini. Si vous n'êtes pas familier de Bash, voici une petite
description de ce qui s'est passé:

``` bash
for file in *.markdown; do
# ...
done
```

`for - do - done` est une structure d'itération de Bash, en gros l'équivalent
d'une boucle `for` en C, Java, etc. On l'utilise généralement pour itérer
sur les arguments de la ligne de commande, ou bien, comme ici, sur les
fichiers du répertoire. Elle peut s'écrire aussi sur 3 lignes:

``` bash
for x in *
do
ma_commande
done
```

Et même sur une seule ligne: `for x in *; do ma_commande ; done`

``` bash
echo 'ligne à ajouter' >> "$file"
```

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



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

