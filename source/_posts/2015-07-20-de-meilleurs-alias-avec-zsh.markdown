---
layout: post
title: "De meilleurs alias avec zsh"
date: 2015-07-20 13:12
comments: true
categories: [alias, shell, zsh]
---

## `{ Guest Post }`

Pour m'améliorer en tant que dev, j'essaye au maximum de simplifier et d'automatiser mon workflow. L'idée est de passer moins de temps à faire des choses qu'un ordinateur peut faire à ma place, et plus de temps à réfléchir aux problèmes que je cherche à résoudre.

C'est dans cette optique que je me suis mis à ajouter énormément d'alias très courts à mon shell. Un alias revient à automatiser l'action de taper sur les touches pour des commandes fréquentes. Malheureusement, les alias sont sous-utilisés pour plusieurs raisons : on a peur d'oublier la commande qui se cache derrière, un autre dev avec qui on est en train de faire du pair programming aura du mal à comprendre quelles commandes sont exécutées, et souvent on oublie tout simplement qu'on a un alias pour la commande qu'on est en train de taper.

Pour remédier à ces problèmes, j'ai trouvé des solutions que des fonctions avancées de zsh permettent d'implémenter : les alias explicites, et les alias obligatoires.

<!-- more -->

## zsh

zsh est un shell Unix similaire à bash, mais en mieux. On cite souvent son autocompletion et la quantité de plugins disponibles, notamment ceux de [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), comme les principales raisons de passer de bash à zsh.

zsh est installé par défaut sur la plupart des distributions linux et OSX. Si vous ne l'utilisez pas encore, vous pouvez en faire votre shell par défaut avec cette commande :

```
chsh -s $(which zsh)
```

## Les alias explicites


C'est une fonction que @lkdjiin connait bien puisque c'est une des premières améliorations que j'ai apporté à mes alias quand j'ai commencé à travailler avec lui.
Voilà à quoi ça ressemble:

![explicit_aliases](https://cloud.githubusercontent.com/assets/1840367/8545448/16b25cfc-24af-11e5-85ab-69f77424b532.gif)

Afin de ne pas oublier la commande qui se cache derrière un alias, les alias explicite la font s'afficher comme si elle avait été entrée juste après l'alias.
Voici le code à rajouter dans votre .zshrc (le fichier de config que zsh charge avant chaque session) pour activer les alias explicites:

```
preexec_functions=()

function expand_aliases {
  input_command=$1
  expanded_command=$2
  if [ $input_command != $expanded_command ]; then
    print -nP $PROMPT
    echo $expanded_command
  fi
}

preexec_functions+=expand_aliases
```

Les preexec functions de zsh sont des fonctions qui sont appelées après qu'une commande soit lue, et avant qu'elle ne soit exécutée. zsh leur donne comme argument la commande telle qu'elle est entrée par l'utilisateur, et la même commande après l'expansion des alias.

Cette fonction vérifie donc que la version étendue est différente de la version entrée par l'utilisateur (c'est à dire qu'un alias a été utilisé), et le cas échéant affiche un prompt en utilisant la variable `$PROMPT` suivi de la commande.

## Les alias obligatoires

Cette idée plaît parfois un peu moins : pour ne pas oublier l'existence d'un alias, j'ai modifié mon setup pour que zsh refuse d'exécuter une commande si je la tape en entier plutôt que de me servir d'un alias.

![mandatory_alias](https://cloud.githubusercontent.com/assets/1840367/7302861/9e437a96-e9ec-11e4-9978-9f33f21bd7d9.gif)

Et voici l'implémentation dans le .zshrc:

```
function check-alias-and-accept {
  if [ $BUFFER ]; then

    ALIAS=`alias -L | grep -e "=[\'\"]\?${BUFFER}[\'\"]\?$"`

    if [ $ALIAS ]; then
      echo
      echo "You have this alias:"
      echo
      echo $ALIAS
      echo
      echo "Use it!"

      zle kill-whole-line
      zle reset-prompt
    else
      zle accept-line
    fi
  else
    zle accept-line
  fi
}

zle -N check-alias-and-accept
bindkey '^J' check-alias-and-accept
bindkey '^M' check-alias-and-accept
```

J'utilise ici une fonction peu connue de zsh: le Zsh Line Editor, ou zle. Il s'agit du programme que zsh execute pendant qu'il lit les évènements clavier de l'utilisateur (alors que les precommand functions sont exécutées après que l'utilisateur ai fini d'entrer la commande). C'est ce programme qui lance l'autocomplétion lorsque qu'on appuie sur TAB par exemple.

L'implémentation est un peu plus compliquée que pour les alias explicites. Regardons un peu plus en détails ce qui se passe:

- Les trois dernières lignes sont pour enregistrer la fonction `check-alias-and-accept` à la liste des fonctions que zle peut appeler, et binder la touche Entrée à l'appel de cette fonction.
- A l'intérieur de `check-alias-and-accept`, on commence par vérifier que l'utilisateur a entré quelque chose, ce qui est indiqué par la variable `$BUFFER` initialisée par zle. Si rien n'a été entré (dans la branche du else), on appelle tout simplement la fonction `zle accept-line`, qui est celle que zle executerait normalement à l'appui sur la touche Entrée.
- Si il y a une commande, on cherche parmis tous les alias si il y en a un qui correspond. `alias -L` permet d'obtenir la liste de tous les alias de la config, et un grep avec une regexp un peu sauvage permet de les filtrer.
- Si un alias correspond, les fonctions `zle kill-whole-line` et `zle reset-prompt` permettent de revenir à un prompt vide. La commande est donc effacée et n'apparaitra même pas dans l'historique.


## Et bien plus encore

zsh est un shell très puissant lorsqu'on a le courage de lire son manuel, et permet de customizer votre setup de manière très poussée. Pour plus de customization zsh et vim, jetez un coup d'oeil à mes [dotfiles](https://github.com/victormours/dotfiles), et si vous avez des idées pour d'autres améliorations à base de zsh, [envoyez-les moi sur twitter](http://twitter.com/victormours) !

# Qui a écrit cet article ?

{% img https://avatars3.githubusercontent.com/u/1840367?v=3&s=200 %}

**Victor Mours**  
Lead developer chez sleekapp.io, obsessionnel des dotfiles
