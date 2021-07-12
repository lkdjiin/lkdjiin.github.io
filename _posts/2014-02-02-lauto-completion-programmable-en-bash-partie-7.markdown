---
layout: post
title: "L'auto-complétion programmable en Bash - partie 7"
date: 2014-02-02 18:35
legacy: true
tags: [bash, avancé, unix, auto complétion]
---



Cet article est la suite de:
[L'auto complétion programmable en bash: partie 6](/blog/2014/01/29/lauto-completion-programmable-en-bash-partie-6/).

Un motif général et basique, la suite
-------------------------------------------

Après avoir regardé la variable `COMPREPLY` dans le dernier article,
on étudie aujourd'hui les variables `COMP_WORDS` et `COMP_CWORD`.

<!-- more -->

On va encore modifier notre script, cette fois pour examiner le
contenu de la variable `COMP_WORDS`:

{% highlight bash %}
_mytool()
{
    COMPREPLY=${COMP_WORDS[@]}
}
complete -F _mytool mytool
{% endhighlight %}

N'oubliez pas de sourcer:

    $ source /etc/bash_completion.d/mytool

Testons:

    $ mytool foo bar[TAB]

est remplacé par:

    $ mytool foo mytool foo bar

On voit que `COMP_WORDS` est un tableau qui contient chaque éléments
de notre ligne de commande, au moment où celle ci est envoyée à
l'auto-complétion.

Voyons maintenant `COMP_CWORD`:

{% highlight bash %}
_mytool()
{
    COMPREPLY=( $COMP_CWORD )
}
complete -F _mytool mytool
{% endhighlight %}

Si je tapes:

    $ mytool foo bar[TAB]

Cela va être remplacé par:

    $ mytool foo 2

Donc, `COMP_CWORD` contient l'index de l'élément de la ligne de
commande dans lequel se trouve le curseur.

On a maintenant tous les éléments en main pour comprendre le script
présenté la dernière fois comme le motif de base pour
l'auto-complétion:

{% highlight bash %}
_mytool()
{
    local current=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "new compile test" -- $current) )
}
complete -F _mytool mytool
{% endhighlight %}

Il reste juste à expliquer la dernière ligne:

{% highlight bash %}
complete -F _mytool mytool
{% endhighlight %}

La fonction `complete`, interne à Bash, s'occupe bien sûr de l'auto-complétion
du programme `mytool`. Le nombre d'options possibles est important, vous pouvez
jeter un oeil au manuel si vous avez le temps. On se contentera ici de l'option
`-F`. Cette option est très intéressante, elle prend en argument le nom d'une
fonction (ici `_mytool`) qui va calculer la complétion. Cette fameuse option
`-F` permet aussi à `complete` de savoir qu'elle doit chercher des résultats
dans la variable `COMPREPLY`. Notez la convention utilisée: la fonction
`_mytool` calcule la complétion du programme `mytool`.



À demain.



