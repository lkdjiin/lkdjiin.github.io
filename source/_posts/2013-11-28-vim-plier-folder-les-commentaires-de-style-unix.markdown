---
layout: post
title: "Vim: Plier (folder) les commentaires de style Unix"
date: 2013-11-28 16:39
comments: true
categories: [vim, commentaires, intermédiaire, fold]
---

{% level 2 %}

Certains fichiers sources contiennent une proportion non négligeable de
commentaires, ou documentation interne. Par exemple, le fichier
[ruby/lib/csv.rb](https://github.com/ruby/ruby/blob/trunk/lib/csv.rb) de
Ruby contient à ce jour 46% de lignes qui sont des commentaires. Quand on
cherche à étudier ces sources  pour la première fois, le nombre
important de commentaire est un frein pour naviguer ou se repérer dans
un tel fichier. Aujourd'hui je montre comment replier facilement les
ensembles de lignes commençant par `#`.

<!-- more -->

Présentation
-------------
Les fonctions de Vim qu'on va utiliser sont les suivantes:

    Fonction      Raccourci
    =======================
    foldmethod    fdm
    foldexpr      fde

Vim comporte plusieurs méthodes de pliage (*folding*) de code, qu'on
spécifie avec `foldmethod`. Ici on va utiliser la méthode `expr`, qui
permet de faire à peu près tout ce qu'on veut. L'expression sera
spécifiée avec `foldexpr`.

Essai en direct
-------------
On va d'abord voir comment ça marche en entrant les commandes en direct live.
Ouvrez le fichier
[ruby/lib/csv.rb](https://github.com/ruby/ruby/blob/trunk/lib/csv.rb)
(ou un autre avec beaucoup de commentaires de style Unix) et entrez ce qui
suit:

``` vim
:set fdm=expr
:set fde=getline(v:lnum)=~'^\\s*#'
```

Badaboum ! Tout les commentaires sont pliés. Explications:

    getline(v:lnum)

Cette fonction retrouve une ligne du fichier. `v:lnum` est une variable
prédéfinie qui contient le numéro de la ligne courante.

    =~

Cet opérateur a le même sens qu'en Ruby, par exemple. Autrement dit,
est-ce que la chaîne à ma gauche correspond à la regex à ma droite ?

    '^\\s*#'

C'est notre regex: début de ligne (`^`), suivi par un nombre quelconque
de blancs (`\\s*`), suivi par le caractère `#`.

L'expression spécifiée dans `foldexpr` (ou comme ici `fde`) sera appelée
par Vim sur chaque ligne du fichier.

Embarqué dans le fichier
----------
Maintenant qu'on sait comment ça marche, voyons comment faire pour ne pas
avoir à taper ces 2 lignes à chaque fois.

Si vous écrivez la ligne suivante dans un fichier, typiquement à la fin, les
commandes seront executées automatiquement à l'ouverture du fichier.
C'est un truc utile à connaitre.

``` vim
# vim:fdm=expr:fde=getline(v\:lnum)=~'^\\s*#':
```

Notez qu'il a fallu échapper le `:` de `v:lnum` pour que ça fonctionne.

Une fonction
----------
Une fonction dans le `.vimrc` sera plus intéressante:

``` vim
function FoldUnixComments()
  set foldmethod=expr
  set foldexpr=getline(v:lnum)=~'^\\s*#'
endfunction
```

Pour l'executer:

``` vim
:call FoldUnixComments()
```

Conclusion
---------
La méthode présentée ici n'est pas parfaite. En effet `foldmethod=expr`
*écrase* votre ancienne méthode. Néanmoins, elle me semble suffisante
quand il s'agit juste d'étudier un fichier.

À demain.

{% connexe %}

