---
layout: post
title: "Gestion des dotfiles avec Stow"
date: 2026-03-11 8:00
comments: true
tags: [ linux, fish ]
---

Au fil du temps j'ai essayé plusieurs méthodes pour gérer mes dotfiles et
autres scripts utilisateur. Et je n'ai jamais rien trouvé qui soit à la fois simple et efficace.
À tel point que depuis quelques années je me contentais de les mettre sur une
clé USB, sans réelle organisation.

C'était avant de découvrir GNU Stow il y a quelques semaines (bien qu'il existe
depuis longtemps).

<!-- more -->

## Stow, ça sert à quoi ?

Stow réplique une structure de fichiers d'un répertoire enfant dans son
répertoire parent en créant des liens symboliques. Voici un exemple basique
pour mieux comprendre :

{% highlight bash %}
    parent/
    └── enfant/
        └── config.txt
{% endhighlight %}

Je me place dans le répertoire enfant et j'active stow :

{% highlight bash %}
    cd parent/enfant
    stow .
{% endhighlight %}

Un lien symbolique est créé dans le répertoire parent :

{% highlight bash %}
    parent/
    ├── config.txt@ -> enfant/config.txt
    └── enfant/
        └── config.txt
{% endhighlight %}

On peut supprimer les liens créés si besoin :

{% highlight bash %}
    cd parent/enfant
    stow -D .
{% endhighlight %}

{% highlight bash %}
    parent/
    └── enfant/
        └── config.txt
{% endhighlight %}

Bien sûr cet exemple n'est pas très impressionnant, mais dans la réalité c'est
aussi facile avec 100 fichiers disséminés dans plusieurs niveaux de sous-dossiers.

## Organisation en modules

Je vais organiser le dossier enfant en différents modules. Ce qui veux dire que
je vais ranger mes dotfiles dans des sous-dossiers par fonctionnalité,
plutôt que de tout mettre directement à la racine du dossier enfant. Mais c'est
seulement un choix personnel. J'aurais par exemple les modules suivants :

- bash
- fish
- git
- vim

Ce qui sera peut-être suffisant pour gérer plusieurs machines sans passer par des
branches git. Je verrai bien à l'usage.

Et si j'ai besoin de modules spéciaux pour des machines précises :

- system_a
- system_b
- system_c

## Installation de stow

{% highlight bash %}
    $ sudo apt update
    $ sudo apt install stow
    $ stow --version
    $ stow --help
{% endhighlight %}

Je crée mon dossier enfant, `.dotfiles` semble un nom idéal ;)

{% highlight bash %}
    $ mkdir ~/.dotfiles
    $ cd ~/.dotfiles/
{% endhighlight %}

L'option -v (verbose) est intéressante pour être tenu au courant de se qu'il se passe :

{% highlight bash %}
    $ stow -v test
    LINK: .local/bin/test_bin.txt => ../../.dotfiles/test/.local/bin/test_bin.txt
    LINK: .test_root.txt => .dotfiles/test/.test_root.txt
    $ stow -vD test
    UNLINK: .local/bin/test_bin.txt
    UNLINK: .test_root.txt
{% endhighlight %}

Maintenant il faudra lire le [manuel de stow](https://www.gnu.org/software/stow/manual/stow.html)
pour tenter de dénicher d'autres options utiles ;) Par exemple :

- `--dotfiles` pour simplifier la gestion des fichiers cachés.
- `--simulate` pour plus de sûreté.
- `--target` pour modifier le répertoire cible.

## Un premier module

Je commence avec bash, que j'utilise très peu sur cette machine. Donc si je le
plante ça ne sera pas très grave. Remarquez comment je transforme le '.' en 'dot-'.
Et aussi que je déplace physiquement les fichiers à gérer (ça n'est pas un
copier/coller) :

{% highlight bash %}
    $ mkdir ~/.dotfiles/bash
    $ mv ~/.bashrc ~/.dotfiles/bash/dot-bashrc
    $ mv ~/.profile ~/.dotfiles/bash/dot-profile
{% endhighlight %}

Par précaution je ferais toujours une vérification pour être sûr que je suis
dans le repertoire enfant :

{% highlight bash %}
    $ cd ~/.dotfiles/
{% endhighlight %}

Je m'assure que tout se passera bien en effectuant une simulation :

{% highlight bash %}
    $ stow --simulate --dotfiles --verbose bash
    LINK: .bashrc => .dotfiles/bash/dot-bashrc
    LINK: .profile => .dotfiles/bash/dot-profile
    WARNING: in simulation mode so not modifying filesystem.
{% endhighlight %}

On voit que l'option `--dotfiles` remplace 'dot-' par '.' dans les liens
symboliques.

Maintenant je peux le faire vraiment :

{% highlight bash %}
    $ stow --dotfiles --verbose bash
    LINK: .bashrc => .dotfiles/bash/dot-bashrc
    LINK: .profile => .dotfiles/bash/dot-profile
{% endhighlight %}

## Un autre module

Un autre module avec une hiérarchie de dossiers plus profondes, pour l'exemple :

{% highlight bash %}
    $ mkdir -vp ~/.dotfiles/fish/.config/fish/functions/
    $ mv -v ~/.config/fish/config.fish ~/.dotfiles/fish/.config/fish/
    $ mv -v ~/.config/fish/functions/* ~/.dotfiles/fish/.config/fish/functions/
    $ stow --dotfiles --verbose fish
{% endhighlight %}

## Utilisation de l'option --target

Le comportement par défaut de stow est de créer les liens dans le répertoire
parent, ce qui n'est pas toujours désirable. Par exemple j'aime bien ranger mes
scripts perso dans `/usr/local/bin`. Dans ce cas l'option `--target` sera utile :

{% highlight bash %}
    $ mkdir -vp ~/.dotfiles/usr_scripts
    $ sudo mv -v /usr/local/bin/mon_script ~/.dotfiles/usr_scripts/
    $ sudo stow --dotfiles --verbose --target=/usr/local/bin usr_scripts
{% endhighlight %}

De cette manière `/usr/local/bin` va se substituer au répertoire parent et je
peux ainsi utiliser un unique dépot global (~/.dotfiles/).

## Ajouter git

Ajouter git permettra de facilement sauvegarder et utiliser les dotfiles sur
d'autres machines.

{% highlight bash %}
    $ cd ~/.dotfiles/
    $ git init
{% endhighlight %}

J'ajoute aussi un fichier README pour me souvenir des commandes à utiliser.
Comme j'ai choisi une organisation en module je n'utilise pas `stow .` et je
peux donc mettre ce que je veux à la racine du dossier `~/.dotfiles/` sans craindre
que ce soit répliqué ailleurs. Extrait de mon README :

{% highlight md %}

## Typical use

Move your file in the right module in folder `~/.dotfiles/`.
Let Stow manage it with:

    $ stow --dotfiles --verbose module_name

For the `usr_scripts` module don't forget to set the target:

    $ sudo stow --dotfiles --verbose --target=/usr/local/bin usr_scripts

To unlink:

    $ stow --dotfiles --verbose -D module_name

{% endhighlight %}

Ça m'étonnerais que j'utilise stow de cette façon au quotidien. Le mot "stow" ne
signifie rien pour moi et je n'ai pas envie de devoir me souvenir de toutes ces
commandes ;) Il y a des chances que je fasse un petit script dans quelques temps
pour me cacher tout ça.

Je serais curieux de savoir si vous connaissiez stow et ce que vous en pensez.
