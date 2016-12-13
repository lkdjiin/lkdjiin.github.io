---
layout: post
title: "Changer de shell, de Bash à Fish"
date: 2016-12-13 19:34
comments: true
categories: [shell, bash, fish]
---

J'avais remarqué le shell Fish il y a plusieurs années. Mais l'accroche de son
site web m'avais plutôt fait penser à une blague :

> Finally, a command line shell for the 90s

Heureusement pour moi, j'y suis repassé il y a quelques mois. Et cette fois
j'ai compris que c'était du sérieux. Je me suis promis de revenir dès que
possible pour essayer ce shell.

On est le week end. J'ai quelques heures devant moi. C'est parti pour
un test. Et comme directement c'est l'effet WAO, je me dis que je
vais y aller *à la dure*, en l'installant sur l'ordinateur du boulot.

Voici mes premières impressions après deux jours d'utilisation.

<!-- more -->

## Auto complétion

La première chose qui me saute aux yeux, c'est l'auto complétion, qui va de pair
avec les suggestions faites par le shell.

L'auto complétion par la touche TAB semble bien plus performante qu'en Bash. Un
coup d'œil dans la doc me dit qu'il sera aussi plus simple de fournir les
auto complétions pour mes propres programmes.

Ensuite, des suggestions apparaissent au fur et à mesure que l'on entre des
caractères et c'est puissant. Ça n'existe tout simplement pas dans Bash. Ctrl+F
permet d'accepter toute la ligne, alors que Alt+F accepte un seul mot.

## Coloration syntaxique

Fish colore votre ligne de commande en temps réel. Y a pas à dire, ça change de
Bash. Et c'est utile : une commande inconnue ou mal orthographiée apparait en
rouge, on repère une variable au milieu d'une chaîne de caractères, etc.

## Retrouver les anciennes commandes

Avec Bash, j'ai une configuration qui me permet de taper les premières lettres
d'une commande, et de faire défiler (avec les touches fléchées) toutes les
commandes historiques qui commencent par ces quelques lettres.

Avec Fish, pas besoin de configurer quoi que ce soit. Ça existe d'emblée, mais
en plus puissant.

## Raccourcis clavier

Pour l'instant je ne retrouve pas tous mes raccourcis (ou astuces).
Par exemple avec Bash `Esc+.` affiche l'argument de la dernière commande. Ça me
manque avec Fish. Mais comme un principe de Fish est «*on peut faire tous ce que
peuvent faire les autres shells*», j'attends de voir.

## Ruby

J'utilise `chruby` depuis un certain temps comme *version manager* et j'ai eu
une petite frayeur en constatant que plus rien ne fonctionnait avec Fish.
Pour mon premier jour sous Fish au boulot, ça a donc été mitigé, même si j'utilise
moins Ruby ces temps ci. Je repassais sous Bash quand il fallait faire du Ruby.

Dans l'après midi je me suis décidé à chercher, et j'ai trouvé ça:
[chruby-fish](https://github.com/JeanMertz/chruby-fish). Sans ce projet j'aurais
certainement cesser là mon utilisation de Fish. Donc un grand merci à son
créateur.

Ça fait très bien le boulot, avec un petit bug tout de même:

```
$ chruby 2.3.1
mkdir: cannot create directory ‘/opt/rubies/ruby-2.3.1/lib/ruby/gems/2.3.0/bin’: Permission denied
```

Pour chaque version de Ruby, il faudra donc créer ce dossier à la main:

    sudo mkdir /opt/rubies/ruby-2.3.1/lib/ruby/gems/2.3.0/bin

## Prompt, thèmes

Je ne vais pas m'étendre sur le sujet, y a tout ce qu'il faut pour
personnaliser son terminal à grands coups de variables et de fonctions.

## Alias et fonctions

Un truc qui m'a fort surpris au tout début : Fish n'a pas d'alias, il faut
utiliser des fonctions à la place. À la fin du deuxième jour d'utilisation
c'était adopté et validé. Voici un classique pour l'exemple, je veux pouvoir
taper `la` à la place de `ls -A` :

```
function la --description 'Like ls with hidden file'
    ls -A $argv
end
```

Un excellent point à propos des fonctions dans Fish : elles sont chargées
*paresseusement*. C'est à dire qu'une fonction est chargée automatiquement la
première fois qu'on l'utilise.

## Conclusion

Le truc avec Fish, c'est que *ça juste marche* &trade;. Avec Bash, il faut des
années de configuration pour obtenir quelque chose de valable. Avec Fish, ton
premier fichier de configuration est vide, inexistant, parce que pas besoin. Et
pourtant ça fonctionne, tout simplement.

Maintenant ça ne fait que deux jours que je suis dessus… C'est le début, tout
est beau. Je verrai à l'usage.

{% connexe %}
