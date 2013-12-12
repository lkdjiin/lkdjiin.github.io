---
layout: post
title: "Remplacer Sed et Awk par Ruby 10: Un exemple d'utilisation"
date: 2013-12-12 21:05
comments: true
categories: [sed, awk, ruby, débutant, vim]
---

{% level 1 %}

Dans un [article précédent](http://lkdjiin.github.io/blog/2013/12/11/les-algorithmes-genetiques-demystifies-42-un-probleme-deconomie/)
sur les algorithmes génétiques, je devais générer des valeurs aléatoires
*en dur* dans un fichier source Ruby. Le code ressemble à ce qui suit:

``` ruby
KnapsackItem.new('ACCOR', 32, 9, 60),
KnapsackItem.new('AIR_LIQUIDE', 97, 7, 32),
KnapsackItem.new('ALSTOM', 25, 5, 6),
KnapsackItem.new('ARCELORMITTAL_REG', 12, 9, 43),
KnapsackItem.new('AXA', 18, 2, 65),
KnapsackItem.new('BNP_PARIBAS', 53, 3, 24),
# ...
```

Le dernier nombre de chaque ligne doit être compris entre 1 et 100.
Voici comment faire en utilisant ce qu'on a appris depuis le début
de cette série [Remplacer Sed et Awk par Ruby](http://lkdjiin.github.io/blog/2013/11/29/remplacer-sed-et-awk-par-ruby/).

<!-- more -->

J'ai tout d'abord écrit mes lignes en mettant la chaîne `ABC` là où je voulais
un nombre aléatoire:

``` ruby
KnapsackItem.new('ACCOR', 32, 9, ABC),
KnapsackItem.new('AIR_LIQUIDE', 97, 7, ABC),
KnapsackItem.new('ALSTOM', 25, 5, ABC),
KnapsackItem.new('ARCELORMITTAL_REG', 12, 9, ABC),
KnapsackItem.new('AXA', 18, 2, ABC),
KnapsackItem.new('BNP_PARIBAS', 53, 3, ABC),
# ...
```

Cela va permettre au script de *trouver* l'endroit où substituer un nombre.

Puis, on lance le script suivant depuis une console:

``` bash
ruby -ple 'r=rand(100)+1;$_.sub!(/ABC/,r.to_s)' fichier_source
```

Explications: `rand(100)+1` génère un nombre aléatoire entre 1 inclus et
100 inclus. `$_.sub!(/ABC/,r.to_s)` opère une substitution de la ligne en
cours de traitement: ABC est remplacé par le contenu de `r`, soit le nombre
aléatoire.

En réalité, je n'ai pas lancé ce script depuis une console, mais directement
dans Vim:

``` vim
:%! ruby -ple 'r=rand(100)+1;$_.sub\!(/ABC/,r.to_s)'
```

Dans ce cas, il faut faire attention à échapper le `!`, sans quoi Vim
n'aimeras pas…

Voilà un exemple simple d'utilisation du mode *sed/awk* de Ruby.

À demain.

{% connexe %}

