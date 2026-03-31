---
layout: post
title: "\"Now playing\" dans le terminal"
date: 2026-03-18 8:00
comments: true
tags: [ fish, musique ]
---

Aujourd'hui un petit script totalement inutile. Donc comme on dit, rigoureusement
indispensable. Je vous propose d'afficher dans le terminal la chanson en cours et la pochette de l'album.

{% img center /images/now-playing.png %}

<!-- more -->

## L'utilitaire playerctl

Voulant comprendre un peu mieux D-Bus, je suis tombé sur le protocole MPRIS,
qui m'a lui-même emmené vers `playerctl`.

C'est un utilitaire minimaliste qui va nous permettre, par exemple, de

- lister les players (`--list-all`)
- connaître l'état des players (`--status`)
- obtenir des métadonnées (`--metadata`)

### La liste des players en cours d'utilisation

{% highlight bash %}
$ playerctl --list-all
firefox.instance_1_233
qmmp
{% endhighlight %}

### L'état d'un player

{% highlight bash %}
$ playerctl --player=qmmp status
Playing
{% endhighlight %}

### Les métadonnées de la chanson en cours

{% highlight bash %}
$ playerctl --player=qmmp metadata
qmmp  mpris:artUrl              file:///home/xavier/Albums/Kraftwerk - The Man·Machine/cover.jpg
qmmp  mpris:length              374200000
qmmp  mpris:trackid             '/org/qmmp/MediaPlayer2/Track/2067028550'
qmmp  xesam:album               The Man·Machine
qmmp  xesam:artist              Kraftwerk
qmmp  xesam:contentCreated      2003
qmmp  xesam:genre               electro
qmmp  xesam:title               The Robots
qmmp  xesam:trackNumber         1
{% endhighlight %}

### Extraction des informations

{% highlight bash %}
$ playerctl --player=qmmp metadata --format "Now playing {% raw %}{{artist}} - {{album}} - {{title}}{% endraw %}"
Now playing Kraftwerk - The Man·Machine - Spacelab
{% endhighlight %}

### L'url de la cover

{% highlight bash %}
$ playerctl --player=qmmp metadata mpris:artUrl
file:///home/xavier/Albums/Kraftwerk - The Man·Machine/cover.jpg
{% endhighlight %}

## Afficher une image dans le terminal avec chafa

Pour rendre la chose un peu plus fun, je vais afficher la pochette de l'album.

Plusieurs utilitaires peuvent faire ça, j'utiliserai ici [chafa](https://github.com/hpjansson/chafa).
Cet utilitaire convertit des images en caractères (unicode ou ASCII). La doc
dit «Character art facsimile generator». Je vous conseille d'ailleurs de lire
cette documentation car il y a énormément d'options disponibles.

### Un exemple simple

{% highlight bash %}
chafa --format=symbols --size=40x40 cover.jpg
{% endhighlight %}

## Le script final

À vous de l'adapter à votre player, à vos envies, etc.

{% highlight bash %}
# Fichier ~./config/fish/functions/now-playing.fish

function now-playing \
  --description 'Show what song is currently playing by Qmmp player'

  set player qmmp
  set present false

  for i in (playerctl --list-all)
    if [ $i = $player ]
      set present true
    end
  end

  if not $present
    echo '🎵 Playing nothing'
    return
  end

  set cover (playerctl --player=qmmp metadata mpris:artUrl)
  echo
  if [ -z $cover ]
    echo "🎵 No cover"
  else
    chafa --format=symbols -w 9 --size=40x40 (string replace 'file://' '' $cover)
  end

  echo
  playerctl --player=qmmp metadata --format "🎵 Now playing {% raw %}{{artist}} - {{album}} - {{title}}{% endraw %}"

  echo
end
{% endhighlight %}

## Ressources

- [playerctl](https://github.com/altdesktop/playerctl)
- [chafa](https://github.com/hpjansson/chafa)
- [qmmp](https://en.wikipedia.org/wiki/Qmmp)
