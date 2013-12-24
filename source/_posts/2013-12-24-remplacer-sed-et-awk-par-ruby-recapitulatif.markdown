---
layout: post
title: "Remplacer Sed et Awk par Ruby: Récapitulatif"
date: 2013-12-24 15:16
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

C'est la fin de cette série. Durant une quinzaine d'articles, on a vu
qu'il était possible de remplacer Sed ou Awk par Ruby, pour faire de
l'édition, de l'analyse ou du filtrage de fichier texte.
Cet article récapitule tout ce qu'on a vu.

<!-- more -->

Dans [Remplacer Sed et Awk par Ruby](http://lkdjiin.github.io/blog/2013/11/29/remplacer-sed-et-awk-par-ruby/)
j'explique l'utilité des langages Sed et Awk, et pourquoi il peut-être
intéressant de les remplacer par Ruby.

Dans [Premier pas](http://lkdjiin.github.io/blog/2013/11/30/remplacer-sed-et-awk-par-ruby-2-premiers-pas/)
on a appris à parcourir les lignes d'un fichier, à utiliser la variable
prédéfinie `$_` et on a approché les blocs BEGIN et END.

Dans [BEGIN et END](http://lkdjiin.github.io/blog/2013/12/01/remplacer-sed-et-awk-par-ruby-3-begin-et-end/)
je parle en détail des blocs BEGIN et END.

Dans [Les options -p et -l](http://lkdjiin.github.io/blog/2013/12/04/remplacer-sed-et-awk-par-ruby-4-les-options-p-et-l/)
on voit comment Ruby peut s'occuper automatiquement de l'affichage des lignes
et des caractères de fin de ligne.

Dans [Accéder aux champs/colonnes](http://lkdjiin.github.io/blog/2013/12/05/remplacer-sed-et-awk-par-ruby-5-acceder-aux-champs-slash-colonnes/)
on voit que Ruby peut *splitter* automatiquement les différents champs d'une
ligne.

Dans [Séparateur de champs](http://lkdjiin.github.io/blog/2013/12/07/remplacer-sed-et-awk-par-ruby-6-separateur-de-champ/)
je montre comment spécifier les séparateurs de champs.

Dans [Modifier/sauvegarder les données](http://lkdjiin.github.io/blog/2013/12/08/remplacer-sed-et-awk-par-ruby-7-modifier-slash-sauvegarder-les-donnees/)
on apprend à modifier un fichier *en place* et à faire automatiquement une
copie de sauvegarde.

Dans [Scripts sur la ligne de commande](http://lkdjiin.github.io/blog/2013/12/09/remplacer-sed-et-awk-par-ruby-8-script-sur-la-ligne-de-commande/)
je montre comment écrire un *one liner*.

Dans [Utiliser la bibliothèque standard](http://lkdjiin.github.io/blog/2013/12/10/remplacer-sed-et-awk-par-ruby-9-utiliser-la-bibliotheque-standard/)
on voit comment charger une gem sur la ligne de commande.

Dans [La gem English](http://lkdjiin.github.io/blog/2013/12/14/remplacer-sed-et-awk-par-ruby-11-la-gem-english/)
on apprend à utiliser des noms qui ont du sens à la place des variables
prédéfinies.

Dans [Numéro de ligne](http://lkdjiin.github.io/blog/2013/12/17/remplacer-sed-et-awk-par-ruby-12-numero-de-ligne/)
on apprend que Ruby tient automatiquement le compte des numéros de ligne.

Dans [Séparateurs en sortie](http://lkdjiin.github.io/blog/2013/12/18/remplacer-sed-et-awk-par-ruby-13-separateurs-en-sortie/)
on voit comment modifier les valeurs du séparateur de champs et du séparateur
d'enregistrements/lignes.

Dans [Flip flop](http://lkdjiin.github.io/blog/2013/12/21/remplacer-sed-et-awk-par-ruby-flip-flop/)
je montre une technique très utilisée dans Sed ou Awk pour traiter des
groupes de lignes.

Enfin, dans
[Un exemple d'utilisation](http://lkdjiin.github.io/blog/2013/12/12/remplacer-sed-et-awk-par-ruby-10-un-exemple-dutilisation/)
et [Un dernier exemple](http://lkdjiin.github.io/blog/2013/12/22/remplacer-sed-et-awk-par-ruby-un-dernier-exemple/)
je montre deux exemples réels.

Voilà, avec cette série je pense que vous avez tout ce qu'il faut pour
traiter vos logs, fichiers csv et autres joyeusetées en Ruby. Joyeux Noël !

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

