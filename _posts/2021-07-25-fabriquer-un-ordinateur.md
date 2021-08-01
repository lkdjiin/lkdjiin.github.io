---
layout: post
title:  "Fabriquer un ordinateur"
date:   2021-07-25 17:30:18 +0200
comments: true
tags:
---

Depuis quelques mois, et pour de nombreux mois encore, un de mes projets
personnel est la fabrication d'un petit ordinateur d'amateur.

Objectif général
----------------
Mon objectif est de fabriquer un ordinateur pour comprendre comment ça fonctionne
«à l'intérieur».

Pour clarifier mon propos je vais définir :

1. ordinateur
2. fabriquer
3. comprendre le fonctionnement

### C'est quoi un ordinateur ?
Par ordinateur j'entends une machine qui effectue des calculs, tant arithmétiques
que logiques, et qui peut-être programmée. La programmation implique une forme
de mémoire. Les entrées/sorties, bien que nécessaires, ne sont pas très importantes
pour mon cas d'utilisation. Modifier et lire directement le contenu de la mémoire me suffirait.

C'est donc la définition d'une machine largement moins complexe que nos
ordinateurs modernes.

### C'est quoi fabriquer un ordinateur ?
Il ne s'agira pas d'assembler des pièces toutes faites. Par fabriquer, je veux dire
prendre des composants électroniques de base et les souder ensemble.
Par "composants de base", je cible dans un premier temps les transitors et les
diodes.

### Comprendre le fonctionnement ?
Je veux savoir ce qu'il se passe au niveau électronique. Pas au niveau des electrons,
faut quand même pas exagérer. Je veux savoir comment des composants électroniques
peuvent agir de concert pour additionner des nombres ou stocker de l'information.

Je pourrais bien sûr lire un tas de livre sur le sujet, et je l'ai déjà
fait, mais je ne vais pas m'en contenter. Pour vraiment comprendre, j'ai besoin
de faire.

Une machine à calculer
----------------
Je vais commencer avec la technologie RTL (Resistor Transistor Logic). Après
tout, c'est quand même cette technologie qui a guidé les missions Apollo, même
si c'était déjà sous forme de circuits intégrés.

Par contre j'ai du me rendre rapidement à l'évidence, mes calculs préliminaires
montraient que même un ordinateur 5 bits avec au plus quelques dizaines de mots
de mémoire nécessiterait plus de 1000 transistors et consommerait plusieurs
ampères. Sans parler de la place qu'un tel «petit monstre» prendrait ; je n'ai pas
l'intention de consacrer un meuble entier à sa réalisation.

J'ai donc abandonné à contrecoeur l'idée de fabriquer tout de suite mon premier
ordinateur, et je suis parti sur une machine à calculer très simple. Ce calculateur
aura l'avantage d'être peu gourmand en place et en puissance (du moins, comparé
à un «full» ordinateur). Il me permettra de concevoir et construire une ALU (Arithmetic and Logic Unit), qui
est le coeur d'un CPU (Central Processing Unit). Ce calculateur utilisera aussi un mot de mémoire.

La machine à calculer sera batie uniquement avec des NOR gates, tout comme l'ordinateur
d'Apollo. Je la limiterai à seulement 4 bits. Ça semble bien peu, mais ça me
permettra d'utiliser un truc : je pourrai remplacer les multiplexeurs par des
toggle switchs physiques et ainsi économiser pas mal de place et de transistors.

{% blockquote Charles Petzold - The Hidden Language of Computer Hardware and Software - ch12 %}
«Addition is the most basic of arithmetic operations, so if we want to build a
computer |...|, we must first know how to build something that adds two numbers
together. |...| addition is just about the only thing that computers do. If we
can build something that adds, we're well on our way to building something that
uses addition to also substract, multiply, divide, calculate mortgage payments,
guide rockets to Mars, play chess |...|.»
{% endblockquote %}

Rendez-vous prochainement pour la réalisation d'une première porte logique.

{% include serie_001.md %}
