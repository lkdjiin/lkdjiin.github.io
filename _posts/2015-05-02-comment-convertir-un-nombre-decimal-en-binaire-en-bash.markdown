---
layout: post
title: "Comment convertir un nombre décimal en binaire en Bash ?"
date: 2015-05-02 12:20
legacy: true
tags: [bash, débutant, binaire, hexadécimal, ruby, one liner]
---



Pour convertir un nombre décimal en binaire, en Bash, suivez ce tweet&nbsp;:
[https://twitter.com/climagic/status/593842202314420224](https://twitter.com/climagic/status/593842202314420224).

Et voici la conversion du décimal 27 en son équivalent binaire&nbsp;:

{% highlight bash %}
$ Dec2Bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1});echo ${Dec2Bin[27]} 
00011011
{% endhighlight %}

Alors, comment ça marche ?

{% img center /images/binary.jpg %}

<!-- more -->

Pour commencer, voici comment faire un tableau en bash, qui va contenir les 3
chaînes `foo`, `bar`, et `baz`. Ne soyez pas surpris par le manque de guillemets
autour des chaînes, Bash est fait pour traiter du texte.

{% highlight bash %}
$ myarray=(foo bar baz)
{% endhighlight %}

Et voici comment afficher le contenu de ce tableau.

{% highlight bash %}
$ echo ${myarray[@]}
foo bar baz
{% endhighlight %}

On peut bien sûr accéder aux éléments du tableau séparément&nbsp;:

{% highlight bash %}
$ echo ${myarray[0]}
foo
$ echo ${myarray[1]}
bar
$ echo ${myarray[2]}
baz
{% endhighlight %}

Pour connaître la taille d'un tableau, voici la syntaxe&nbsp;:

{% highlight bash %}
$ echo ${#myarray[@]}
3
{% endhighlight %}

Appliquons ce nouveau savoir au tableau `Dec2Bin`, qui contient…

…

…des trucs&nbsp;:

{% highlight bash %}
$ Dec2Bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
{% endhighlight %}

Combien a-t-il d'éléments ?

{% highlight bash %}
$ echo ${#Dec2Bin[@]}
256
{% endhighlight %}

256 ? Et ça ressemble à quoi ?

{% highlight bash %}
$ echo ${Dec2Bin[@]}
00000000 00000001 00000010 00000011 00000100 00000101 00000110 00000111 00001000 
00001001 00001010 00001011 00001100 00001101 00001110 00001111 00010000 00010001
...
11101010 11101011 11101100 11101101 11101110 11101111 11110000 11110001 11110010 
11110011 11110100 11110101 11110110 11110111 11111000 11111001 11111010 11111011 
11111100 11111101 11111110 11111111
{% endhighlight %}

Tranquille, `Dec2Bin` est un tableau qui contient 256 chaînes représentant les
nombres binaires de 0 à 255.

Les crochets `{}` créent un *range* :

{% highlight bash %}
$ echo {0..1}
0 1
$ echo {a..f}
a b c d e f
{% endhighlight %}

Plusieurs crochets `{}` les uns à la suite des autres produisent toutes les
permutations possibles&nbsp;:

{% highlight bash %}
$ echo {0..1}{0..1}
00 01 10 11
{% endhighlight %}

Et on peut mettre tout ça dans un tableau&nbsp;:

{% highlight bash %}
$ a=({0..1})
$ echo ${a[@]}
0 1
$ a=({0..1}{0..1})
$ echo ${a[@]}
00 01 10 11
$ a=({0..1}{0..1}{0..1})
$ echo ${a[@]}
000 001 010 011 100 101 110 111
{% endhighlight %}

Et voilà, il faut encore savoir qu'ici, le point-virgule sert à joindre 2 lignes de
code en une seule&nbsp;:

{% highlight bash %}
$ Dec2Bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
$ echo ${Dec2Bin[27]}
00011011
{% endhighlight %}

## Bonus 1 - Le même en hexadécimal

Et si on voulait convertir un nombre décimal en hexadécimal plutôt qu'en
binaire ? Il faudrait générer toutes les permutations entre deux suites
`0 1 2 3 4 5 6 7 8 9 A B C D E F`&nbsp;:

{% raw %}
{% highlight bash %}
$ echo {{0..9},{A..F}}{{0..9},{A..F}}
00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 12 13 14 15 16 17 18 19 1A 
1B 1C 1D 1E 1F 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F 30 31 32 33 34 35 
36 37 38 39 3A 3B 3C 3D 3E 3F 40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F 50 
51 52 53 54 55 56 57 58 59 5A 5B 5C 5D 5E 5F 60 61 62 63 64 65 66 67 68 69 6A 6B 
6C 6D 6E 6F 70 71 72 73 74 75 76 77 78 79 7A 7B 7C 7D 7E 7F 80 81 82 83 84 85 86 
87 88 89 8A 8B 8C 8D 8E 8F 90 91 92 93 94 95 96 97 98 99 9A 9B 9C 9D 9E 9F A0 A1 
A2 A3 A4 A5 A6 A7 A8 A9 AA AB AC AD AE AF B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 BA BB BC 
BD BE BF C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 CA CB CC CD CE CF D0 D1 D2 D3 D4 D5 D6 D7 
D8 D9 DA DB DC DD DE DF E0 E1 E2 E3 E4 E5 E6 E7 E8 E9 EA EB EC ED EE EF F0 F1 F2 
F3 F4 F5 F6 F7 F8 F9 FA FB FC FD FE FF
{% endhighlight %}
{% endraw %}

{% raw %}
{% highlight bash %}
$ Dec2Hex=({{0..9},{A..F}}{{0..9},{A..F}});echo ${Dec2Hex[27]}
1B
{% endhighlight %}
{% endraw %}

## Bonus 2 - Le même en Ruby

On peut faire la même chose en Ruby en utilisant `repeated_permutation`&nbsp;:

{% highlight irb %}
>> [0,1].repeated_permutation(8).to_a.each{|e| puts e.join}
00000000
00000001
00000010
00000011
00000100
00000101
...
11111010
11111011
11111100
11111101
11111110
11111111
{% endhighlight %}

Il peut-être intéressant de comparer les deux versions&nbsp;:

{% highlight bash %}
$ ruby -e "puts [0,1].repeated_permutation(8).to_a[27].join"
00011011
{% endhighlight %}

{% highlight bash %}
$ Dec2Bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1});echo ${Dec2Bin[27]} 
00011011
{% endhighlight %}

## Bonus 3 - Encore plus court

Pour finir, on peut faire plus court avec Bash en utilisant `{0,1}` au lieu de
`{0..1}` puisqu'il y a seulement deux éléments&nbsp;:

{% highlight bash %}
$ Dec2Bin=({0,1}{0,1}{0,1}{0,1}{0,1}{0,1}{0,1}{0,1});echo ${Dec2Bin[27]} 
00011011
{% endhighlight %}


