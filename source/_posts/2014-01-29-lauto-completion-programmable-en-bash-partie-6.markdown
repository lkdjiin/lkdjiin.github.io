---
layout: post
title: "L'auto-complétion programmable en Bash - partie 6"
date: 2014-01-29 20:47
comments: true
categories: [bash, avancé, unix, auto complétion]
---

{% level 3 %}

Cet article est la suite de:
[L'auto complétion programmable en bash: partie 5](/blog/2014/01/15/lauto-completion-en-bash-partie-5/).

Un motif général et basique
-------------------------------------------

Nous avons écrit un petit [programme pour tester](/blog/2014/01/14/lauto-completion-programmable-en-bash-partie-4/),
puis nous avons écrit [un script d'auto-complétion très simple](/blog/2014/01/15/lauto-completion-en-bash-partie-5/).
Reprenons notre jeu de rôle: nous avons un programme `mytool` qui
attend une des trois commandes suivantes: `new`, `compile` ou
`test`. On va ajouter ceci: la commande `new` peut prendre
l'option `--without-test` et la commande `compile` peut prendre
l'option `--verbose`. Ça reste encore très simple, mais on ne peut
déjà plus se servir uniquement de la fonction `complete`, vue
la dernière fois.

Voyons donc le motif général utilisé par beaucoup de scripts
d'auto-complétion:

<!-- more -->

``` bash /etc/bash_completion.d/mytool
_mytool()
{
    local current=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "new compile test" -- $current) )
}
complete -F _mytool mytool
```

Le script ci-dessus fait exactement la même chose que notre simple
script de la dernière fois, qui était le suivant:

``` bash /etc/bash_completion.d/mytool
complete -W "new compile test" mytool
```

Mais il le fait d'une manière plus compliquée. En effet,
pourquoi faire simple… Les explications viendront plus tard.

En fait, pour aller plus loin, il est important de comprendre le rôle
des variables `COMP_WORDS`, `COMP_CWORD` et `COMPREPLY`. Pour ça, on
va modifier notre script, et chercher à comprendre ce que
représente `COMPREPLY`:

``` bash /etc/bash_completion.d/mytool
_mytool()
{
    COMPREPLY=( this is some replacement )
}
complete -F _mytool mytool
```

Pour qu'il soit pris en compte tout de suite, il faut le sourcer:

    $ source /etc/bash_completion.d/mytool

Alors, que fait-il ? Si je tapes `mytool foo bar[TAB]`, voici ce que
le script sort:

    $ mytool foo bar[TAB]
    is           replacement  some         this   

COMPREPLY accepte un tableau de chaînes, qui sont les suggestions que
nous renvoit l'auto-complétion. On note au passage que ces suggestions
sont triées alphabétiquement.

Modifions à nouveau notre script:

``` bash /etc/bash_completion.d/mytool
_mytool()
{
    COMPREPLY=( replacement )
}
complete -F _mytool mytool
```

Cette fois, COMPREPLY représente un tableau d'un seul élément.
N'oubliez pas de sourcer le script avant de le tester:

    $ mytool foo bar[TAB]

devient:

    $ mytool foo replacement

Vous devriez maintenant avoir bien compris à quoi sert la variable
`COMPREPLY`.

La prochaine fois, on regardera en détail les variables `COMP_WORDS`
et `COMP_CWORD`.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
