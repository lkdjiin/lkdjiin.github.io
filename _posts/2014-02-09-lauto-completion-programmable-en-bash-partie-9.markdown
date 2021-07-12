---
layout: post
title: "L'auto-complétion programmable en Bash - partie 9"
date: 2014-02-09 18:55
legacy: true
tags: [bash, avancé, unix, auto complétion]
---



Cet article est la suite de:
[L'auto complétion programmable en bash: partie 8](/blog/2014/02/08/lauto-completion-programmable-en-bash-partie-8/).

Une complétion améliorée
-------------------------------------------

On voit aujourd'hui deux fonctions bien utiles lors de l'écriture
de votre script d'auto-complétion: `_get_comp_words_by_ref` et
`compopt`.

<!-- more -->

On va ajouter une option `--format=` à notre commande `test`. Ce que
je veux, c'est pouvoir écrire quelque chose comme ça:

    $ mytool test --format=documentation

Il faut donc que:

    $ mytool test -[TAB]

nous donne ceci:

    $ mytool test --format=

Mais contrairement à ce qu'il se passe jusqu'ici, je ne veux pas
que l'auto-complétion ajoute un espace après `--format=`.

Voici tout d'abord le script qui fait ça :

{% highlight bash %}
_mytool()
{
    local cur prev command options
    COMPREPLY=( )
    _get_comp_words_by_ref cur prev
    commands='new compile test'

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
    elif [[ "$cur" == -* ]]; then
        command=${COMP_WORDS[1]}
        case $command in
            new)
                options='--without-test'
                ;;
            compile)
                options='--verbose'
                ;;
            test)
                options='--format='
                compopt -o nospace
                ;;
        esac
        COMPREPLY=( $( compgen -W "$options" -- "$cur" ) )
    fi
}
complete -F _mytool mytool
{% endhighlight %}

Et maintenant, je vais détailler les nouveautés. D'abord, vous avez
peut-être remarqué que la ligne:

{% highlight bash %}
    _get_comp_words_by_ref cur prev
{% endhighlight %}

a remplacé les deux lignes suivantes
([voir article précédent]()):

{% highlight bash %}
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
{% endhighlight %}

C'est plus simple, plus lisible, plus propre. Cette fonction,
`_get_comp_words_by_ref`, se trouve dans le script `/etc/bash_completion`,
que je vous invite à étudier. Ce fichier défini plusieurs fonctions
utiles pour la complétion.

Voyons maintenant l'ajout de la nouvelle option:

{% highlight bash %}
            test)
                options='--format='
                compopt -o nospace
                ;;
{% endhighlight %}

La nouveauté est ici `compopt -o nospace`. La fonction `compopt` permet
d'allumer/éteindre certaines options pour la complétion en cours. Ici on
demande de ne pas ajouter d'espace à la fin de la chaîne renvoyée par
la complétion.



À demain.



