---
layout: post
title: "Remplacer Sed et Awk par Ruby 11: La gem English"
date: 2013-12-14 16:59
comments: true
categories: [sed, awk, ruby, débutant, gem]
---

{% level 1 %}

Après avoir vu [un exemple d'utilisation](http://lkdjiin.github.io/blog/2013/12/12/remplacer-sed-et-awk-par-ruby-10-un-exemple-dutilisation/) du mode *sed/awk* de Ruby au travers
d'un *one liner*, on regarde aujourd'hui la gem English, qui facilite
énormement la
vie pour l'écriture des scripts.

<!-- more -->

On a vu jusqu'à présent deux variables globales, j'ai nommé `$_` et 
`$;`. Ces noms sont justes barbares et imprononçables. Et des variables
globales de ce genre, il y en a quelques autres qui vont nous être utiles.
Voyons voir si vous êtes capable de deviner ce qu'elles représentent:
`$,`, `$\`, `$/` et `$.`. Vous avez deviné ? Non ? C'est là qu'entre en
jeu [la gem English](http://ruby-doc.org/stdlib-2.0.0/libdoc/English/rdoc/English.html). Cette gem va nous permettre d'accéder à ces
variables à l'aide de noms compréhensibles par le commun des mortels:

       Nom court   Nom long
    $; $FS         $FIELD_SEPARATOR
    $, $OFS        $OUTPUT_FIELD_SEPARATOR 
    $/ $RS         $INPUT_RECORD_SEPARATOR
    $\ $ORS        $OUTPUT_RECORD_SEPARATOR
    $. $NR         $INPUT_LINE_NUMBER
    $_             $LAST_READ_LINE

Pour avoir accès à ceci dans un script, il faudra charger la gem dans
un bloc BEGIN:

``` ruby
BEGIN { require 'English' }
```

Alors quand se servir des noms courts, des noms longs ? Tout dépend de
votre *background* et de votre tâche.

Si vous débutez en Ruby, si vous devez écrire un script long et/ou complexe,
si le script doit être maintenu pendant des mois ou plus, si il est maintenu
par plusieurs personnes, utilisez les noms longs.

Si vous (et votre équipe) avez une expérience de Awk, les noms courts peuvent
être une solution raisonnable.

Quand aux noms *barbares*, réservez les pour les *one liners*, les scripts
courts *one shot* et les séances de masochisme.

À demain.

{% connexe %}
