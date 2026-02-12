---
layout: post
title: "Utiliser une API météo avec Ruby"
date: 2026-02-12 8:00
comments: true
tags: [ ruby, api ]
---

_Tutoriel pour écrire de A à Z une commande de prévision météo, en Ruby,
intégré dans votre shell Fish, utilisant une API gratuite au format Json et les
capacités de mise en forme des outils Unix_

C'est le titre auquel j'avais pensé en premier lieu, mais c'était un peu trop long ;)

Pourtant c'est exactement ce que je vous propose de faire aujourd'hui.
Taper `météo` dans votre terminal et obtenir la température, la probabilité de
pluie et une description du temps pour chaque heure de la journée :

    $ météo
     0h  12°  70%  Pluie légère
     1h  12°  58%
     2h  12°  38%  Couvert
     3h  12°  20%  Couvert
     4h  12°  20%  Couvert
     5h  11°  25%  Couvert
     6h  11°  18%  
     7h  11°  43%  
     8h  12°  25%  
     9h  12°  33%  Couvert
    10h  12°  38%  
    11h  12°  30%  
    12h  13°  23%  Nuageux
    13h  13°   8%  
    14h  14°  13%  Couvert
    15h  14°  13%  Couvert
    16h  14°   8%  Nuageux
    17h  13°   0%  Couvert
    18h  13°  20%  Couvert
    19h  12°  30%  
    20h  11°  60%  
    21h  11°  85%  Pluie légère
    22h  11°  95%  Pluie forte
    23h  12°  93%  Pluie forte

Et si dans ce tutoriel je me contenterai de quelques prévisions pour la journée,
vous pourrez bien sûr l'adapter à vos envies et à vos besoins.

<!-- more -->



## Une API

L'idée m'a pris en utilisant [wttr.in](https://wttr.in/). En creusant un peu j'ai compris que
cette application utilise une API gratuite de prévision météorologique et qu'il en existe beaucoup.
Donc il m'a fallu en choisir une.

J'en ai testé trois ou quatre, et j'ai retenu [Open Meteo](https://open-meteo.com/).
Gratuit, pas de compte à créer, pas besoin de clé API, pas besoin de fournir sa carte bancaire, pas de surprises.
Mais vous pourrez en choisir une autre selon vos besoins, elles fonctionnent toutes plus ou moins de la
même manière. En guise d'exemple rapide, l'appel suivant récupère les prévisions de température pour chaque heures sur les 7 prochains jours aux coordonnées GPS de la tour Eiffel :

    curl https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.29&hourly=temperature_2m

Pour la petite histoire j'avais prévu initialement d'utiliser l'API de météo France.
Mais c'était avant de comprendre dans la douleur qu'il fallait
un bac+42 en météorologie pour pouvoir en tirer quelque chose.

## Récupérer le Json avec Ruby

Pas besoin d'en faire des tonnes. On veut seulement les
prévisons pour notre ville, les mêmes jours après jours.

{% highlight ruby %}
# fichier meteo-get.rb

# L'url de base, avec vos coordonnées GPS
api = 'https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.29'

# Les données horaires à obtenir
hourly = '&hourly=temperature_2m,precipitation_probability,weather_code'

# Ne nous préoccupons pas de la time zone
tz = '&timezone=auto'

# Les données du jour uniquement
forecast = '&forecast_days=1'

url = "#{api}#{hourly}#{tz}#{forecast}"

# Vous voudrez peut-être enlever l'option no-progress-meter pendant la
# mise au point ou le débug
command = "curl --no-progress-meter '#{url}' > data.json"

system(command)
{% endhighlight %}

Vous utiliserez ce script avec `ruby meteo-get.rb`.

Une fois que vous avez mis au point la requête et que vous récupérez les données
dont vous avez besoin dans un fichier Json, on passe à la suite.

## Exploitation du Json

Avoir deux fichiers source Ruby, un pour obtenir les données et un autre pour les traiter,
vous donnera plus de flexibilité sans effort.

{% highlight ruby %}
# Fichier meteo-parse.rb

require 'json'

# Vous pouvez définir les descriptions que vous voulez.
WEATHER_CODE = {
  '0' => 'Ciel clair',
  '1' => 'Dégagé',
  '2' => 'Nuageux',
  '3' => 'Ciel couvert',
  '51' => 'Pluie',
}

# Cette classe s'occupe de fournir les données.
class MeteoData
  def initialize
    @data = JSON.load_file('data.json')
  end

  def temperature(hour)
    hourly['temperature_2m'][hour].round
  end

  def precipitation(hour)
    hourly['precipitation_probability'][hour]
  end

  def description(hour)
    desc = hourly['weather_code'][hour].to_s
    WEATHER_CODE[desc]
  end

  private

  def hourly
    @data['hourly']
  end
end

# Cette classe affiche les données groupées.
class Printer
  def initialize(data)
    @data = data
  end

  def display
    0.upto(23).each do |hour|
      t = @data.temperature(hour)
      p = @data.precipitation(hour)
      d = @data.description(hour)
      puts "#{hour}h #{t}° #{p}% #{d}"
    end
  end
end

printer = Printer.new(MeteoData.new)
printer.display
{% endhighlight %}

Et un extrait de la sortie obtenue avec `ruby meteo-parse.rb` :

    8h 9° 25%
    9h 12° 33% Ciel couvert
    10h 12° 38% Ciel couvert
    11h 12° 30% Ciel couvert
    12h 13° 23% Ciel couvert
    13h 14° 8% Ciel couvert
    14h 14° 13% Ciel couvert
    15h 14° 13% Ciel couvert
    16h 14° 8% Nuageux
    17h 13° 0% Ciel couvert
    18h 13° 20% Ciel couvert

## Mise en forme du texte

Bien sûr on pourrait gérer la mise en forme directement avec Ruby dans le fichier
`meteo-parse.rb`, mais pourquoi se compliquer la vie ? L'utilitaire `column` va
nous faire ça en 2 secondes. Option `-t` pour afficher les données sous forme de
tableau et option `-R` pour aligner sur la droite les colonnes 1, 2 et 3.

    $ ruby meteo-parse.rb | column -t -R 1,2,3

Le même extrait que précédemment avec la mise en forme de `column` :

     8h  9° 25%
     9h 12° 33% Ciel couvert
    10h 12° 38% Ciel couvert
    11h 12° 30% Ciel couvert
    12h 13° 23% Ciel couvert
    13h 14°  8% Ciel couvert
    14h 14° 13% Ciel couvert
    15h 14° 13% Ciel couvert
    16h 14°  8% Nuageux
    17h 13°  0% Ciel couvert
    18h 13° 20% Ciel couvert

## Réunion des deux fichiers Ruby

On enchaîne les fichiers `meteo-get.rb` et `meteo-parse.rb` simplement en les
chargeants. Vous aurez peut-être besoin à un moment donné d'une logique plus
complexe, par exemple pour gérer les erreurs dues à une API inaccessible. Mais
pour l'instant ça fera l'affaire :

{% highlight ruby %}
# Fichier meteo.rb

require_relative 'meteo-get.rb'
require_relative 'meteo-parse.rb'
{% endhighlight %}

On peut alors utiliser une seule ligne de commande :

    $ ruby meteo.rb | column -t -R 1,2,3

Mais vous conservez toujours la possibilité d'utiliser `meteo-get.rb` et/ou `meteo-parse.rb`
pour effectuer de la mise au point, de la maintenance, des tests, etc…

## Fonction Fish

Voyons maintenant un moyen parmi d'autres pour utiliser une commande
`météo` dans le terminal, où que vous soyez. J'utilise le shell [Fish](https://fishshell.com/)
mais vous trouverez certainement une manière de faire la même chose si vous
utiliser un autre shell.

{% highlight bash %}
# Fichier météo.fish
function météo --description 'Display weather report'
  set d (pwd)                        # (1)
  cd ~/Apps/meteo/                   # (2)
  ruby meteo.rb | column -t -R 1,2,3 # (3)
  cd $d                              # (4)
end
{% endhighlight %}

1. Se souvenir du dossier en cours
2. Aller là où se trouve votre application
3. Lancer l'application (plus tard il faudra sûrement gérer les possibles erreurs)
4. Revenir au dossier initial


## Installation

C'est la dernière étape. On range la fonction fish à sa place :

    $ cp météo.fish ~/.config/fish/functions/

Puis les fichiers Ruby à la leur. Ici c'est `Apps/meteo/` mais ça peut-être où
vous voulez :

    mkdir ~/Apps/meteo/
    cp meteo*.rb ~/Apps/meteo/

Et voilà, vous disposez désormais de la commande `météo` dans votre terminal.
