---
layout: post
title: "Effets sonores (Jetpack Hero)"
date: 2025-05-05 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Ajouter des effets sonores en _one shot_ est très simple avec DragonRuby.

<!-- more -->

Pour ça on ajoute une entrée dans le hash `args.audio`. Le son sera joué
immédiatement, puis l'entrée dans `args.audio` sera supprimée automatiquement
quand le son arrivera à son terme. Exemple :

{% highlight ruby %}
args.audio[:the_key] = { input: "sounds/the_sound.wav" }
{% endhighlight %}


Voici ce que ça donne en contexte. Jouer un petit son quand le personnage
ramasse un bidon de fuel :

{% highlight ruby %}
  args.state.fuel.each do |f|
    if args.state.hero.intersect_rect?(f)
      args.state.hero.jetpack_power += 20
      args.state.hero.jetpack_power = args.state.hero.jetpack_power.clamp(0, 100)
      f.used = true
      args.audio[:fuel] = { input: "sounds/fuel.mp3" }
    end
  end
{% endhighlight %}

Si on réécrit la même clé dans le hash `args.audio` alors que le son n'est pas
terminé, celui-ci sera rejoué du début. Ça peut-être utile mais parfois ce n'est pas ce qu'on veut.
Pour éviter de relancer le son si il est toujours en jeu il suffit de tester la
présence de la clé dans le hash :

{% highlight ruby %}
args.audio[:jetpack] = { input: "sounds/jetpack.wav" } unless args.audio[:jetpack]
{% endhighlight %}

Pour finir, voici trois sites qui me servent tout le temps pour créer ou obtenir
des effets sonores :

[freesound](https://freesound.org/)

[chiptone](https://sfbgames.itch.io/chiptone)

[jsfxr](https://sfxr.me/)


## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
