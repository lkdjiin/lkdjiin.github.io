---
layout: post
title: "Présentation de Gopher"
date: 2018-07-21 09:06
comments: true
categories: [ gopher, protocole, internet ]
---

En 1997, ma maigre connexion internet était facturée chèrement à la seconde.
J'utilisai encore beaucoup Gopher qui était plus rapide que le web pour
chercher des documents purement textuels. À cette époque je ne m'intéressais
pas au fonctionnement de Gopher, je voulais seulement que ça aille vite.  21
ans après, alors que je redécouvre cette partie d'internet que j'avais oublié,
je vais prendre le temps de voir comment Gopher fonctionne.

<!-- more -->

Le protocole Gopher est très simple _"by design"_. D'abord un client contacte
un serveur, qui ne répond rien. Puis le client envoie l'identifiant d'une
ressource au serveur (un _selecteur_ dans le jargon Gopher), qui envoie en
réponse le document ou le menu correspondant et ferme la connexion.
Et c'est presque tout. Un document est un fichier quelconque et un menu est un
fichier texte avec une structure minimale, voir même minimaliste.

Pour explorer Gopher, nous pourrions utiliser un client texte (`apt-get install
gopher`), ou un plugin pour notre navigateur. Mais pour voir un peu ce qu'il se
passe sous le capot, utilisons plutôt l'utilitaire `netcat` pour simuler un
client. Gopher écoute le port 70 par défaut :

    $ netcat gopher.quux.org 70

À ce moment la connexion est établie et le serveur attend que vous lui envoyiez
un sélecteur. Appuyez directement sur la touche Entrée pour envoyer un
sélecteur vide, ce qui a pour effet de selectionner le dossier courant sur le
serveur distant. Le serveur répond immédiatement avec quelques lignes
représentant un menu. En voici une sélection (j'ai remplacé les tabulations par
des `|`) :

    0About This Server|/About This Server.txt|gopher.quux.org|70
    1Archives|/Archives|gopher.quux.org|70

Chaque ligne contient 5 zones séparées par une tabulation, à l'exception des
deux premières zones qui sont accollées :

1. Le type de document. Un 0 pour un document texte, un 1 pour un dossier. Il existe plusieurs autres types.
2. La description du document. C'est une sorte de titre. Par exemple `About This Server`.
3. Le sélecteur, qui identifie une ressource sur un serveur. Par exemple `/About This Server.txt`.
4. L'adresse du serveur où se trouve la ressource.
5. Le port utilisé par Gopher sur le serveur de la ressource.

On voit à cette description que Gopher est une espèce de système de fichier distribué.

Pour suivre un lien du menu, on ouvre une nouvelle connexion :

    $ netcat gopher.quux.org 70

Et cette fois on envoie un sélecteur :

    /About This Server.txt

Le serveur envoie le document correspondant au sélecteur avant de fermer la connexion :

    Welcome to the gopher server at quux.org!

    This is one of the world's few maintained, modern gopher servers.  On it,
    you will find a huge collection of information, files, software, archives,
    [...]

Les menus sont donc tout simplement des hyper-liens, comme dans le web. La
grande différence, c'est que dans le web les hyper-liens sont internes aux
documents, ce qui nécessite un langage (le HTML) pour écrire ces documents.
Alors qu'avec Gopher les liens sont externes aux documents, dans des menus ;
ils peuvent donc être dans n'importe quel format et écrit par n'importe qui, en
théorie.

Connaissiez vous Gopher ? L'avez vous déjà utilisé ? L'utiliser vous encore ?

À bientôt.
