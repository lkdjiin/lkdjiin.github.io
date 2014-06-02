---
layout: post
title: "Un algorithme génétique en Julia - partie 15"
date: 2014-06-02 21:02
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Après avoir pondu [une première version](blog/2014/06/01/un-algorithme-genetique-en-julia-partie-14/)
de l'algorithme hier, je me demande ce que je pourrais améliorer. C'était
un programme sympa pour découvrir Julia, mais je n'ai fait que gratter la
surface de ce langage.

<!-- more -->

Donc, voici ce que je compte/espère faire encore avec ce programme pour
comprendre un peu mieux Julia:

- Retirer les nombres magiques restants.
- Retirer les abbreviations restantes.
- Documenter les fonctions, sinon dans un mois, j'aurais tout oublié !
- Essayer une version récursive de la fonction `run`.
- Lire quelques tutos pour voir ce que je peux en tirer.
- Lire du code julia pour mieux *sentir* (le code source de Julia *itself*
  serait un bon début).
- Mettre le code sur github et le donner à lire/critiquer à des développeurs qui
  connaissent le langage.
- Comprendre pourquoi avec 10.000 individus de 100 gènes, l'empreinte
  mémoire est de 800 Mo ! Ça me semble beaucoup…
- Écrire le même en Ruby et comparer le temps d'exécution.

Voilà, il devrait donc y avoir encore pas mal d'articles sur le langage
Julia ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
