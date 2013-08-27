---
layout: post
title: "Bien débuter avec Vim: Recherche de texte"
date: 2013-08-27 10:14
comments: true
categories: [vim, débutant]
---

{% level 1 %}

Aujourd'hui je montre comment rechercher une chaîne de caractères dans un
fichier avec Vim: les commandes, les options et un petit truc en plus…

<!-- more -->

Les commandes utiles
--------------------
Pour rechercher un texte dans le fichier, on utilise la commande `/` suivie
du texte à rechercher et de la touche entrée. Ainsi:

    /texte

va chercher toutes les occurences de «texte» dans le fichier.

Pour se déplacer parmi les occurences trouvées, on utilise `n` et `N`. `n`
va à l'occurence suivante tandis que `N` va à l'occurence précédente.

Attention, la commande de recherche `/` ne tient pas compte des *mots*.
Je m'explique: `/xxx` va trouver les 4 expressions suivantes.

1. xxx
2. aaaxxx
3. xxxbbb
4. aaaxxxbbb

Parfois c'est ce que l'on veut, parfois non. Pour modifier ce comportement
on utilise `\<` et `\>`, respectivement pour signifier le début et la fin
d'un mot. Ainsi `\<xxx\>` ne trouvera que l'expression n° 1. `\<xxx` trouvera
la n° 1 et la n° 3. Quand à `/xxx\>`, elle trouvera la n° 1 et la n° 2.

Les options
-----------
Voici quelques options à utiliser dans votre fichier .vimrc.

``` vim
set incsearch
```

La recherche sera mise en évidence au fur et à mesure de la frappe clavier,
et non pas seulement après la touche entrée. `incsearch` signifie
*incremental search*.

``` vim
set ignorecase smartcase
```

Ces deux options marchent souvent de pair. `ignorecase` permet d'ignorer la
différence minuscule/majuscule, ainsi `/texte` trouvera «texte», «TEXTE» et
«Texte». `smartcase` repassera en mode différenciation des 
minuscules/majuscules si vous saisissez une majuscule, ainsi `/Texte` trouvera
«Texte» mais pas «TEXTE» ni «texte».

``` vim
set hlsearch
```

Cette option sert à mettre en évidence la recherche, autrement dit à la
surligner.

Supprimer la mise en évidence du texte après une recherche
-----------------------------
Une fois que vous avez fait ce que vous aviez à faire avec votre recherche,
celle-ci reste surlignée, ce qui devient vite très agaçant (pour rester poli).
Pour effacer le surlignage, on utilise la commande `nohlsearch`:

``` vim
:nohlsearch
```

On aura évidemment intérêt à mapper cette commande, par exemple sur 
`<Leader>h`:

``` vim
nnoremap <Leader>h :nohlsearch<CR>
```

Personnellement, je n'ai pas de mappage pour cette commande: je ne m'en
sert tout simplement pas. Pour supprimer la mise en évidence de la
dernière recherche je tape juste `/xx`. Vous pouvez utiliser `/yy` ou `/ww`
ou tout ce qui tombe bien sous vos doigts. Le principe est de rechercher
une chaîne qui n'existe pas, ce qui a pour effet d'effacer la dernière
mise en évidence.

À demain.

{% connexe %}

