---
layout: post
title: "L'auto-complétion programmable en Bash - partie 8"
date: 2014-02-08 14:10
comments: true
categories: [bash, avancé, unix, auto complétion]
---

{% level 3 %}

Cet article est la suite de:
[L'auto complétion programmable en bash: partie 7](/blog/2014/02/02/lauto-completion-programmable-en-bash-partie-7/).

Une complétion plus étoffée
-------------------------------------------

Après avoir étudié les variables `COMPREPLY`, `COMP_WORDS`, `COMP_CWORD`,
et le motif minimal, voici maintenant un programme plus utile.

<!-- more -->

Je veux que `mytool new` réponde à la seule option `--without-test`.
Donc:

    $ mytool new -[TAB]

doit donner:

    $ mytool new --without-test

Je veux aussi que `mytool commpile` réponde seulement à `--verbose`, donc:

    $ mytool compile -[TAB]

doit donner:

    $ mytool compile --verbose

Quant à `mytool test`, il ne prend aucune option.

Voici sans plus tarder un programme qui fait ça:

``` bash
_mytool()
{
    local cur prev command options
    COMPREPLY=( )
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    commands='new compile test'

    if [[ $COMP_CWORD -eq 1 ]] ; then
        COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
    else
        command=${COMP_WORDS[1]}
        if [[ "$cur" == -* ]]; then
            case $command in
                new)
                    options='--without-test'
                    ;;
                compile)
                    options='--verbose'
                    ;;
            esac
            COMPREPLY=( $( compgen -W "$options" -- "$cur" ) )
        fi
    fi
}
complete -F _mytool mytool
```

Ok, Bash n'est pas le plus lisible des langages, mais si vous avez suivi
tous les articles précédent, vous êtes en mesure de suivre la logique
de ce programme. Voilà ce que donne l'algorithme:

    Si le curseur est en position 1
      Compléter avec les commandes
    Sinon
      Trouver la commande courante
      Si le mot sous le curseur commence par '-'
        Compléter les options suivant la commande courante

Quelques points précis maintenant : on calcule le mot sous le curseur
dans `cur` et le mot précédent dans `prev`:

``` bash
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
```

On place toutes les commandes dans une variable `commands`,

``` bash
    commands='new compile test'
```

ce qui permet de calculer les complétions possibles de la manière
suivante (plus lisible et flexible quand on a beaucoup de commandes):

``` bash
        COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

