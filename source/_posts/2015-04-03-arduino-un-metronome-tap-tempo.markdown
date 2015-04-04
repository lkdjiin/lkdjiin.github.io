---
layout: post
title: "Arduino : Un métronome tap tempo"
date: 2015-04-03 18:35
comments: true
categories: [débutant, arduino, musique, éléctronique]
---

{% level 1 %}

J'aimerais fabriquer un métronome *tap tempo* avec l'arduino. C'est un projet à
moyen terme, et
comme souvent, il pourrait être bénéfique de diviser le projet en plusieurs
petites parties. Donc, avant de tenter la programmation du tap tempo, je vais
faire un métronome tout simple avec juste une LED.

Les composants
--------------

Coté composants, on a seulement besoin d'une LED et d'une résistance (220 Ohms
ça ira).

{% img center /images/metronome1_bb.png %}

<!-- more -->

Un premier code naif
------------------------

Le premier jet est tout simple&nbsp;:

``` cpp
const byte LED_PIN = 2;

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  delay(100);
  digitalWrite(LED_PIN, LOW);
  delay(600);
}
```

Une fois compilé et envoyé dans l'arduino, la LED clignote toutes les 0,7
secondes. Nous avons un métronome visuel !

C'est simple, non ? Mouais. Trop simple, bien sûr. Ce code est problèmatique
pour la fabrication d'un métronome. Alors afin de comprendre pourquoi, parlons
un peu du tempo.

Le tempo
--------

Pour le musicien, le tempo est une suite de clics (ou tic, ou tac, ou poum, ou
tchak, ou clac). Ces clics, qui ont la particularité de se succéder à
intervalles réguliers, marquent la **vitesse** de la musique.

Le tempo (donc la vitesse de la musique) est indiqué à l'aide d'un nombre qui
représente le nombre de clics par minute.
Par exemple un tempo de 60 nous indique qu'il doit y avoir 60 clics dans une minute,
ou plus simplement 1 clic par seconde. Autre exemple, un tempo de 120 indique
120 clics par minute, soit 2 clics par seconde, ou encore 1 clic toutes les
0,5 secondes.

Voyons maintenant quelques formules. Pour trouver la fréquence F, en secondes,
il faut diviser 60 par le tempo (noté T)&nbsp;:

{% math %}
F = 60 / T
{% endmath %}

Pour obtenir cette fréquence en millisecondes, il faut multiplier le résultat
précédent par 1000&nbsp;;

{% math %}
F = 60 / T \times 1000
{% endmath %}

Le code arduino ci-dessus envoit un clic toutes les 0,7 secondes, à quel
tempo cela correspond-t-il ? Pour calculer le tempo, on divise 60 par la
fréquence en secondes&nbsp;:

{% math %}
T = 60 / F
{% endmath %}

Donc, une fréquence de 0,7 seconde, comme celle de notre code arduino,
correspond à un tempo de \\(60 / 0,7\\). Soit à peu près 86.

Le problème de la boucle de code
--------------------------------

Maintenant on peut regarder le souci de ce code&nbsp;:

``` cpp
void loop() {
  digitalWrite(LED_PIN, HIGH);
  delay(100);
  digitalWrite(LED_PIN, LOW);
  delay(600);
}
```

Partons de l'hypothèse qu'en plus des deux `digitalWrite`, mon code doit
aussi&nbsp;:

- calculer l'intensité de la LED suivant le beat.
- jouer du son et ausssi calculer son intensité suivant le beat.
- s'occuper de plusieurs LEDs, peut-être avec des motifs.
- écrire le tempo et d'autres informations sur un écran LCD.
- tout ce que vous pourrez imaginer d'autre ;)

Imaginons maintenant que l'ensemble de ces actions prennent 30 millisecondes
(0,03 secondes). Dans ce cas le tempo sera de \\(60 / 0,73\\). Soit à peu près 82.
Donc plus du tout la valeur de 86 qu'on avait trouvé tout à l'heure. **Notre
métronome n'est pas fiable !** Il ne vaut rien, arg.

{% img center /images/facepalm.jpg %}

Faire et ne pas attendre
------------------------

Pour remédier à ce problème nous demandons à l'arduino d'allumer la LED toutes
les 700 millisecondes et non pas **d'attendre** pendant 700 millisecondes.
Pour cela nous gardons une trace du dernier moment où la LED a été allumée
(dans `oldTime`) et nous comparons cette trace avec le moment présent
(`currentTime`) à chaque passage dans la boucle&nbsp;:

``` cpp
const byte LED_PIN = 2;
// In millisecondes.
const long FREQUENCY = 700;

long currentTime;
long oldTime;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  currentTime = 0;
  oldTime = 0;
}

void loop() {
  currentTime = millis();

  if(currentTime >= oldTime + FREQUENCY) {
    digitalWrite(LED_PIN, HIGH);
    delay(100);
    digitalWrite(LED_PIN, LOW);
    oldTime = currentTime;
  }
}
```

Ça fonctionne pour notre métronome, bien qu'il reste encore 100 millisecondes
gachées (avec `delay(100);`). La prochaine fois on verra un moyen de se
débarasser de cette attente inutile.

{% connexe %}

