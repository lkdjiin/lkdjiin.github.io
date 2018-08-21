---
layout: post
title: "Comment créer votre propre localisation sous Linux"
date: 2018-08-21 13:20
comments: true
categories: [ linux, configuration, date, localisation, locale, lang, lc_time ]
---

Un article récent 
[«Configurer Linux pour utiliser une représentation de date logique (ISO 8601)»](https://mayeu.me/blog/configurer-linux-pour-utiliser-une-representation-de-date-logique-iso-8601/) a retenu mon attention. L'auteur y parle de la configuration des
variables locales sur Linux. Des variables telles que `LANG`, `LC_NUMERIC`, et plus particulièrement `LC_TIME`.
Ça m'a fait penser qu'après 21 ans d'utilisation de Linux, je n'avais jamais
pris le temps de regarder comment fonctionnent ces variables de configuration.
Quand tu écris `LANG=fr_FR`, qu'est ce qu'il se passe vraiment ?

<!-- more -->

## Introduction

Pour celles et ceux qui découvrent ces variables de configuration, voici une
introduction rapide. Très rapide…

Pour connaitre votre configuration actuelle, utilisez `locale` :

    $ locale
    LANG=fr_FR.UTF-8
    LANGUAGE=
    LC_CTYPE="fr_FR.UTF-8"
    LC_NUMERIC="fr_FR.UTF-8"
    LC_TIME="fr_FR.UTF-8"
    [...]

Toutes les variables ne sont pas forcement renseignées, c'est normal.

Pour connaitre les valeurs des *locales* qui sont à votre disposition,
utilisez `locale -a` :

    $ locale -a
    C
    C.UTF-8
    en_AG
    en_AG.utf8
    en_AU.utf8
    en_BW.utf8
    en_CA.utf8
    en_DK.utf8
    en_GB.utf8
    [...]
    fr_FR.utf8

Ce ne sont pas **toutes les valeurs existantes**, mais seulement celles que
vous pouvez utiliser tout de suite sans rien compiler. Par exemple, la
commande `date` utilise la variable `LC_TIME` pour savoir ce qu'elle doit afficher.
Par défaut, c'est la valeur `fr_FR` qui est utilisée chez moi (voir la
sortie de `locale`)&nbsp;:

    $ date
    lundi 20 août 2018, 17:20:53 (UTC+0200)

Mais je peux utiliser une autre valeur, par exemple `en_DK`, ou encore
`en_GB`&nbsp;:

    $ LC_TIME=en_DK.utf8 date
    Mon Aug 20 17:19:16 CEST 2018
    $ LC_TIME=en_GB.utf8 date
    Mon 20 Aug 17:19:47 CEST 2018

Pour connaître les autres valeurs de locales auxquelles vous avez droit,
consulter le fichier `/etc/locale.gen`&nbsp;:

    $ cat /etc/locale.gen
    [...]
    # fr_CH.UTF-8 UTF-8
    # fr_FR ISO-8859-1
    fr_FR.UTF-8 UTF-8
    [...]

Les lignes qui débutent par un `#` sont les valeurs que vous pouvez compiler
(en utilisant la commande `locale-gen`).

## Comment ça marche ?

Chaque localisation possède son propre fichier de configuration. Ces fichiers
se trouvent dans `/usr/share/i18n/locales/`.

    $ cat /usr/share/i18n/locales/fr_FR

Dans ces fichiers chaque variable de configuration est décrite dans sa propre section,
comme `LC_TIME` à laquelle je m'intéresse ici&nbsp;:

    LC_TIME
    [...]
    END LC_TIME

À l'intérieur des sections on trouve des chaînes de formatage en Unicode pour
la libc. Voici la partie du fichier `/usr/share/i18n/locales/fr_FR` dont se
servira la commande `date`&nbsp;:

    date_fmt "<U0025><U0041><U0020><U0025><U002D><U0065><U0020>/
    <U0025><U0042><U0020><U0025><U0059><U002C><U0020>/
    <U0025><U0048><U003A><U0025><U004D><U003A><U0025><U0053><U0020>/
    <U0028><U0055><U0054><U0043><U0025><U007A><U0029>"

Si on traduit cette chaîne Unicode (voir par ex. [cette table](https://unicode-table.com/en/)), on obtient ce qui suit&nbsp;:

    %A %-e %B %Y, %H:%M:%S (UTC%z)

On retrouve bien le format de la sortie de `date` (*lundi 20 août 2018, 20:26:17 (UTC+0200)*).
Si vous n'êtes pas familier de cette notation, jetez un œil sur la fonction [strftime](http://www.faximum.com/manual.d/client.server.d/manpages.23.html)
du langage C.

## Je veux ma propre locale

Plutôt que *lundi 20 août 2018, 20:26:17 (UTC+0200)*, je veux que la date
s'affiche sous cette forme&nbsp;: **A:2018 M:08 J:20**.
Pourquoi ? Simplement parce que c'est possible !

Je pars d'un fichier de configuration existant que je copie dans mon répertoire
de travail&nbsp;:

    $ cp /usr/share/i18n/locales/fr_FR ./fr_FR@test

Je l'ai appelé `fr_FR@test`. J'aurais aussi pu utiliser un des nombreux codes
de régionalisation réservés pour les utilisateurs, comme `AA`, `OO`, `XX` ou
`ZZ` (voir [ISO 3166-1
alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)). Donc j'aurais pu
nommer mon fichier `fr_ZZ`.

Pour obtenir une date de la forme *A:2018 M:08 J:20*, il faut la chaîne de
formatage suivante : **A:%Y M:%m J:%d**. Traduit (si on peut dire) en Unicode,
cela donne&nbsp;:

    "<U0041><U003A><U0025><U0059><U0020>/
    <U004D><U003A><U0025><U006D><U0020>/
    <U004A><U003A><U0025><U0064>"

Une fois que j'ai mis ça dans mon fichier `fr_FR@test`, je l'envoie dans le dossier `/usr/share/i18n/locales/`&nbsp;:

    $ sudo cp fr_FR@foobar /usr/share/i18n/locales/

Et je le compile pour qu'il soit utilisable par la libc :

    $ sudo localedef -i fr_FR@foobar -c -f UTF-8 fr_FR@test

Je peux maintenant utiliser ma propre locale :

    $ LANG=fr_FR.utf8@test date
    A:2018 M:08 J:20

Et voilà.

## Quelle utilité ?

Comprendre un peu mieux Linux…

Si mon quartier fait sécession et devient un pays autonome, je suis prêt à
créer une nouvelle traduction…

Si vous avez une autre idée, laissez donc un commentaire…
