---
layout: post
title: "Heroku, OVH, les naked domains, et les DNS"
date: 2018-08-30 17:12
legacy: true
tags: [ heroku, ovh, naked domain, dns, php, http, redirection ]
---

## La situation

J'ai un nom de domaine chez OVH, *stonervoice.com*.

J'ai un site chez Heroku, *foobarbaz.herokuapp.com*.

Je veux pouvoir accéder à mon site à l'aide des 2 URLs suivantes&nbsp;:

- [stonervoice.com](https://stonervoice.com)
- [www.stonervoice.com](https://www.stonervoice.com)

## Comment faire

En configurant les [DNS](https://en.wikipedia.org/wiki/Domain_Name_System). Du moins, dans un monde idéal.

<!-- more -->

## Le www facile

Pointer l'adresse *www.stonervoice.com* sur le site chez Heroku est facile et
prend 30 secondes. La commande `heroku domains:add www.stonervoice.com`
s'occupe de la configuration chez Heroku et nous fournit l'adresse (de type
www.votre-site.com.herokudns.com) à utiliser dans le [CNAME](https://en.wikipedia.org/wiki/CNAME_record) chez OVH (ou
même chez n'importe quel autre fournisseur).

## Le problème

**Mais pour l'adresse stonervoice.com, c'est une autre histoire.**

C'est ce qu'on appelle un domaine nu. En anglais on dit naked domain, ou bien
second-level domain.  Et pour enregistrer un domaine nu dans un serveur DNS il
faut une adresse IP (du genre 123.456.78.9), donc fixe, et pas une URL (genre
truc.machin.com.herokudns.blabla), donc qui pourrait utiliser n'importe quelle
IP.  Pour cela, on utilise le type d'enregistrement DNS *A*, et non pas *CNAME*
comme précédemment.

Sauf qu'avec Heroku, ça fonctionne pas. Parce qu'une application Heroku est
derrière un [load balancer](https://en.wikipedia.org/wiki/Load_balancing_(computing)) et n'a pas d'IP fixe. Vous pouvez le vérifier
vous-même&nbsp;:

    $ nslookup www.stonervoice.com
    Address: 54.229.165.195
    Address: 54.171.20.71
    Address: 54.76.58.198
    Address: 54.194.152.6
    Address: 34.249.85.24
    Address: 34.248.164.131
    Address: 34.246.94.179
    Address: 52.49.103.24

Certains fournisseurs de noms de domaine/DNS proposent le type d'enregistrement
*ALIAS* ou *ANAME* qui conviendrait. Mais pas OVH.

Dit autrement : il n'y a aucun moyen pour faire pointer *stonervoice.com* sur
mon application Heroku en utilisant la gestion des DNS d'OVH.

## Quelques solutions rapides mais…

La plus évidente : utiliser un autre fournisseur qu'OVH, qui propose un *ALIAS* ou un *ANAME*. Mais on n'a pas toujours le choix.

La plus hack : prendre une des IPs fournit par le load balancer de Heroku. Mais on y perd tous les avantages du load balancer, et on ne sait pas si cette IP
restera valable dans le temps.

La plus chère : On peut garder le nom de domaine chez OVH et utiliser un autre
gestionnaire de DNS, comme DNS Simple, DNS Made Easy, ou Cloud Flare. On
pourrait aussi utiliser un add-on chez Heroku pour avoir une IP fixe (j'ai pas
essayer, ça devrait logiquement marcher). C'est la solution que je préfère,
mais pour ce projet je ne veux pas commencer à payer des extras tant que je
peux éviter.

## La solution préconisée par Internet

J'ai bien sûr posé la question à Internet, DuckDuckGo pour ma
part, mais j'ai entendu dire que Google marchait bien aussi ;)

On conseille souvent d'utiliser le service *wwwizer*. Vous enregistrez l'IP
que le service vous fournit gratuitement dans vos DNS avec un type *A*, et
chaque requête sur *stonervoice.com* est alors redirigée vers *www.stonervoice.com*.
J'ai essayé tout de suite, et ça fonctionne.

Mais en fait pas vraiment.

D'abord je n'aime pas trop l'idée d'un service qui peut s'arrêter à tout
moment sans me prévenir.  Mais surtout, ça ne fonctionne pas avec https. La requête
*https://stonervoice.com* n'est pas redirigée et échoue avec un *timeout*. (Je
crois que cette redirection https fait partie de leurs services payants).

## Une meilleure solution pour moi : PHP

Utiliser une redirection [HTTP «301 Moved Permanently»](https://en.wikipedia.org/wiki/HTTP_301) comme le fait le service wwwizer
est une bonne idée. Lorsque quelqu'un accède à *stonervoice.com*, cette
personne est redirigée vers *www.stonervoice.com* et le logiciel utilisé a
l'occasion de mettre à jour l'adresse ou de la mettre en cache de manière plus ou
moins permanente.

Puisque chez OVH on dispose d'un plan «web hosting» gratuit avec PHP pour l'achat
d'un nom de domaine, la solution est super simple : on fait une redirection
en PHP. Voici le contenu du fichier `index.php` à déposer chez OVH&nbsp;:

    <?php
    header("Location: https://www.stonervoice.com/", true, 301);
    exit;

Avec en plus l'avantage de rediriger stonervoice.com vers **https**://www.stonervoice.com.

C'est pas idéal comme solution puisque chaque requête sur le *naked domain* ira
taper sur un serveur mutualisé, avec tous les problèmes qui ne manqueront pas
d'arriver… Mais en attendant que le besoin d'évoluer se fasse sentir, c'est la
solution la plus simple, la moins chère, la plus propre et la plus rapide à mettre
en place que j'ai trouvé (le plus long a été l'installation de Filezilla).

Si vous avez d'autres idées/solutions je suis preneur, laissez donc un commentaire.
