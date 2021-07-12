---
layout: post
title: "L'auto-complétion programmable en Bash - partie 10"
date: 2014-02-10 20:45
legacy: true
tags: [bash, avancé, unix, auto complétion]
---



Cet article est la suite de:
[L'auto complétion programmable en bash: partie 9](/blog/2014/02/09/lauto-completion-programmable-en-bash-partie-9/).

Complétion des options longues
-------------------------------------------

Aujourd'hui j'ai envie de voir comment on pourrait utiliser
l'auto-complétion pour les options longues, du genre
`--format=documentation`.

<!-- more -->

L'option `--format=` peut prendre deux valeurs: `dot` ou `documentation`.
Je veux donc obtenir ceci:

    $ mytool test -[TAB]
    $ mytool test --format=[TAB]
    documentation  dot            
    $ mytool test --format=do

    $ mytool test --format=doc[TAB]
    $ mytool test --format=documentation 

Voici une manière d'obtenir ça:

{% highlight bash %}
_mytool_long_options()
{
    case $1 in
        --format)
            options='dot documentation'
            ;;
    esac
    COMPREPLY=( $( compgen -W "$options" -- "$2" ) )
}

_mytool()
{
    local cur prev command options
    COMPREPLY=( )
    _get_comp_words_by_ref cur prev
    commands='new compile test'

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
    elif [[ "$prev" == = ]]; then
        _mytool_long_options "${COMP_WORDS[COMP_CWORD-2]}" "$cur"
    elif [[ "$cur" == = ]]; then
        _mytool_long_options "$prev"
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

# vim: ft=sh ts=4 sw=4
{% endhighlight %}

La fonction `_mytool_long_options` prend un paramètre obligatoire et
un second optionnel. Le premier est le mot *avant* le signe `=` et le
second est l'éventuel mot *après* le signe `=`:

{% highlight bash %}
_mytool_long_options()
{
    case $1 in
        --format)
            options='dot documentation'
            ;;
    esac
    COMPREPLY=( $( compgen -W "$options" -- "$2" ) )
}
{% endhighlight %}

J'ai ajouté deux `elif`, qui regarde si le mot sous le curseur (`$cur`)
ou le mot précédent (`$pre`) est le caractère `=`. Dans ce cas,
on appelle la fonction `_mytool_long_options` qui s'occupe de gérer
la complétion des options du style `--foo=bar`:

{% highlight bash %}
    elif [[ "$prev" == = ]]; then
        _mytool_long_options "${COMP_WORDS[COMP_CWORD-2]}" "$cur"
    elif [[ "$cur" == = ]]; then
        _mytool_long_options "$prev"
{% endhighlight %}

Même si cela fonctionne, je pense pouvoir trouver plus simple, et c'est
ce que j'espère faire dans un prochain article.



À demain.


