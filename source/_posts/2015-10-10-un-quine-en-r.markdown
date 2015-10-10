---
layout: post
title: "Un quine en R"
date: 2015-10-10 18:11
comments: true
categories: [R, quine, répliquant]
---

J'ai lu récemment l'article [generating Quines in Ruby](http://blog.chaps.io/2015/10/01/generating-quines-in-ruby.html) qui m'a beaucoup plu. Et j'ai eu envie d'en faire un dans le langage R.

Alors c'est quoi un quine ? Un quine est un programme informatique
auto répliquant (*self-reproducing*).  Il doit satisfaire à deux conditions:

1. Il produit son code source en tant que unique sortie.
2. Il ne prend aucune entrée, ce qui exclus par exemple de lire un fichier.

<!-- more -->

Voici ma solution en R, elle affiche son code source sur la sortie standard
quand on l'exécute. Je me suis beaucoup inspiré de la solution en C de l'article
original:

``` r quine.r
src <-"\nescape <- function(x) {\n    cat('\"')\n    for(e in strsplit(x, '')[[1]]) {\n        if(e == '\\n') {\n            cat('\\\\n')\n        } else if(e == '\\\\') {\n            cat('\\\\\\\\')\n        } else if(e == '\"') {\n            cat('\\\\\"')\n        } else {\n            cat(e)\n        }\n    }\n    cat('\"')\n}\ncat(\"src <-\")\nescape(src)\nwriteLines(src)"
escape <- function(x) {
    cat('"')
    for(e in strsplit(x, '')[[1]]) {
        if(e == '\n') {
            cat('\\n')
        } else if(e == '\\') {
            cat('\\\\')
        } else if(e == '"') {
            cat('\\"')
        } else {
            cat(e)
        }
    }
    cat('"')
}
cat("src <-")
escape(src)
writeLines(src)
```

Comme il est noté dans l'article original, il est bon de tester sa solution à
l'aide de `diff`. Si la sortie de votre programme et le source sont identiques,
`diff` ne produira aucune sortie, sinon bon débogage ;)

``` bash
$ diff -u quine.r <(Rscript quine.r)
```

Ma solution est beaucoup plus longue que celle qui se trouve sur le [rosetta code](http://rosettacode.org/wiki/Quine#R) par exemple. Mais c'est pas grave, c'était marrant à faire, c'était un bon petit casse-tête qui m'a bien fait réfléchir. Et j'ai même appris une fonction R qui m'était inconnue (`writeLines`).

À vous de jouer maintenant ; tenez moi au courant si vous écrivez un quine, quel
que soit le langage ;)

{% connexe %}
