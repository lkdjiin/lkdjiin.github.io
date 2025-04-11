---
layout: post
title: "Une solution hardware au problème de fluctuation ?"
date: 2025-04-11 8:00
comments: true
tags: [ arduino, midi ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 10 

Y a t-il une solution hardware au [problème de fluctuation](/blog/2025/04/02/lire-un-potentiometre-ii/) de la lecture d'un
potentiomètre ? Et si oui, cette solution vaut-elle le coup par rapport à une
solution logicielle ?

<!-- more -->

## La solution logicielle

Ma [solution logicielle](/blog/2025/04/03/regler-le-probleme-de-fluctuation/) consiste à n'envoyer un nouveau message MIDI que si
la somme des mesures (M) à l'instant T-2 et T-1 est différente de la somme des
mesures à l'instant T-1 et T0.

{% math %}
  M_{t-2}+M_{t-1}\neq M_{t-1}+M_{t0}
{% endmath %}

Le graphique montre la comparaison entre la lecture directe sur la broche
analogique A0 (en bleu), réalisée à chaque itération, et la valeur envoyée au
synthé (en orange), seulement lorsque l'algorithme considère qu'il y a un réel
changement.

{% img center /images/solution-hardware-01.png %}

On voit dans la partie gauche qu'on saute bien les valeurs qui font du va-et-vient.
Mais ce graphique montre aussi le principal défaut de cette solution : le
décalage temporel.

## La solution hardware

Une solution électronique aurait l'avantage d'être instantanée (du moins dans
le sens du langage courant). En branchant un condensateur entre la patte centrale
du potentiomètre et le ground on peut lisser les fluctuations du courant.
(_Faites toujours bien gaffe au sens de branchement d'un condensateur pour éviter
les surprises désagréables_.)

{% img center /images/solution-hardware-02.jpg %}

Pour tester cette solution je sors un potentiomètre dont les pattes s'insèrent
très mal dans la breadboard et je prends des mesures sans toucher à rien. Le
swing est gigantesque, entre 150 et 800 (l'arduino convertit en 10 bits, donc les
valeurs possibles vont de 0 à 1023) :

{% img center /images/solution-hardware-03.png %}

Puis j'insère un condensateur de 10uF (comme dans la photo ci-dessus) et je
reprend des mesures. L'amélioration est spectaculaire. C'est peut-être dur à
voir sur l'image mais maintenant la lecture est stabilisé entre 584 et 586 !

{% img center /images/solution-hardware-04.png %}

## Conclusion

Avec des mauvais potentiomètres, ou des mauvaises connexions, un simple condensateur est une solution
fantastique. Malheureusement, quand les potentiomètres sont bons et offrent déjà
une lecture presque stable, le condensateur ne peut pas aider.


{% include serie_002.md %}

{% include mathjax.html %}
