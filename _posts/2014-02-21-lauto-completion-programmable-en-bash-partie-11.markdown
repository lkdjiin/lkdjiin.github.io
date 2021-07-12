---
layout: post
title: "L'auto-complétion programmable en Bash - partie 11"
date: 2014-02-21 20:53
legacy: true
tags: [bash, avancé, unix, auto complétion]
---



Cet article est la suite de:
[L'auto complétion programmable en bash: partie 10](/blog/2014/02/10/lauto-completion-programmable-en-bash-partie-10/).

Complétion des options longues - suite
-------------------------------------------

Aujourd'hui on voit que `_get_comp_words_by_ref` peut être appellée
avec une option bien utile qui modifie `COMP_WORDBREAKS`.

<!-- more -->

La variable `COMP_WORDBREAKS` contient les caractères qui permettent
de splitter les mots pour la complétion. Voici son contenu:

    $  echo $COMP_WORDBREAKS 
    "'><=;|&(:

On voit que `=` en fait partie, et c'est ce qui rendait un peu compliqué
le [code de la dernière fois](/blog/2014/02/10/lauto-completion-programmable-en-bash-partie-10/).
Grâce à l'option `-n` de la fonction `_get_comp_words_by_ref`, on va pouvoir
simplifier ça:


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
    _get_comp_words_by_ref -n = cur prev
    commands='new compile test'

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
    elif [[ "$cur" == --*=* ]]; then
        _split_longopt
        _mytool_long_options "$prev" "$cur" 
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

Ce code fait la même chose que celui du [dernier article](/blog/2014/02/10/lauto-completion-programmable-en-bash-partie-10/),
mais est bien plus simple et lisible.



À demain.




