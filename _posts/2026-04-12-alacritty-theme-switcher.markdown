---
layout: post
title: "Theme switcher pour Alacritty"
date: 2026-04-12 8:00
comments: true
tags: [ fish, bash ]
---

J'aime bien [Alacritty](https://alacritty.org/). En ce moment c'est mon terminal par défaut. Un autre truc
que j'aime bien, c'est passer d'un thème sombre à un thème clair et vice versa
dans les terminaux et les éditeurs. Et généralement je fais ça plusieurs fois
par jour.

J'ai regardé les solutions existantes pour modifier le thème d'Alacritty, et j'ai décidé de ne pas les utiliser.
Je vais plutôt bricoler la mienne. Mais pourquoi ?

- C'est toujours intéressant de faire par soi-même. Il y a souvent quelque chose
  à en tirer, à apprendre.
- Les solutions existantes ne font pas _exactement_ ce que je veux.
- Je préfère éviter les plugins. Au début c'est rapide, puis
  avant de réaliser ce qu'il se passe on a installé des tas de trucs et on se
  retrouve aux commandes d'une usine à gaz.
- Beaucoup de ce qui existe est basé sur Rust et son gestionnaire de package. Je n'ai pas ça sur ma machine,
  et autant éviter une dépendance de plus...

<!-- more -->

## Configuration du thème

Alacritty a un fichier de configuration plutôt clair, au format [toml](https://toml.io/en/).
Le mien se trouve à `~/.alacritty.toml`.
Sous la balise `[general]`, on renseigne la clé `import` avec le fichier qui
contient le thème. Ici j'utilise le thème `ashes_light` :

{% highlight toml %}
[general]
import = [
  "~/.config/alacritty/themes/ashes_light.toml",
]
{% endhighlight %}

L'objectif du _theme switcher_ sera donc de modifier cette ligne dans le fichier
de config.

## Idée n°1 - sed

Dès lors qu'il faut modifier une ligne dans un fichier, je pense immanquablement
à `sed`. Je vais utiliser l'expression `s/regex/substitution/`. Sed remplacera
la regex par substitution. Reste à trouver une regex qui va correspondre à la ligne
`"~/.config/alacritty/themes/ashes_light.toml"`. Sans correspondre à d'autres lignes
bien sûr. Pas besoin de se prendre la tête, le format toml pouvant contenir des
commentaires je peux ajouter un marqueur dans le fichier de config :

{% highlight toml %}
[general]
import = [
  "~/.config/alacritty/themes/ashes_light.toml", # THEME SWITCHER
]
{% endhighlight %}

Je teste en ligne de commande, et ça fonctionne. De cette manière je peux
remplacer la ligne qui m'intéresse dans le fichier de config par ce que je veux :

{% highlight bash %}
$ sed -e 's/.*THEME SWITCHER/foobar/' test.toml
[general]
import = [
foobar
]
{% endhighlight %}

Les exemples qui suivent sont en Fish, et non en Bash. La seule différence sera
dans la déclaration des variables.

- Bash : `foo = "bar"`
- Fish : `set foo "bar"`

Pour remplacer la ligne par quelque chose de plus utile que simplement `foobar`
il va falloir corser un peu la commande de substitution :

{% highlight bash %}
$ set new_theme "new_theme_name"
$ set line '  "~/.config/alacritty/themes/'$new_theme'.toml", # THEME SWITCHER'
$ sed -e 's@.*THEME SWITCHER@'$line'@' test.toml
[general]
import = [
  "~/.config/alacritty/themes/new_theme_name.toml", # THEME SWITCHER
]
{% endhighlight %}

Maintenant qu'on sait que ça fonctionne il faut effectuer le
remplacement _pour de vrai_ dans le fichier. Pour ça on peut utiliser l'option
`-i` de sed (pour _in place_) :

{% highlight bash %}
$ sed -i -e 's@.*THEME SWITCHER@'$line'@' test.toml
{% endhighlight %}

On en sait suffisament pour écrire deux commandes, `dark` et `light` :

fichier dark
{% highlight bash %}
#!/bin/fish
set new_theme "autumn"
set line '  "~/.config/alacritty/themes/'$new_theme'.toml", # THEME SWITCHER'
sed -i -e 's@.*THEME SWITCHER@'$line'@' ~/.alacritty.toml
{% endhighlight %}

fichier light
{% highlight bash %}
#!/bin/fish
set new_theme "nord_light"
set line '  "~/.config/alacritty/themes/'$new_theme'.toml", # THEME SWITCHER'
sed -i -e 's@.*THEME SWITCHER@'$line'@' ~/.alacritty.toml
{% endhighlight %}

Mais pour ce genre de chose je préfère écrire une fonction fish :

fichier dark.fish
{% highlight bash %}
function dark \
  --description 'Set alacritty dark theme'

    set new_theme "autumn"
    set line '  "~/.config/alacritty/themes/'$new_theme'.toml", # THEME SWITCHER'
    sed -i -e 's@.*THEME SWITCHER@'$line'@' ~/.alacritty.toml
end
{% endhighlight %}

Dès que je tape `dark` ou `light` dans un terminal, le thème change immédiatement.
Ça marche car, par défaut, la config alacritty est en _live reload_. Elle se
recharge automatiquement dès qu'on la modifie.

On pourra aller plus loin en se basant sur cette méthode :

- Supprimer la duplication avec une seule fonction `set-theme` qui prendra un
  argument. On pourra ainsi afficher n'importe quel thème. Et avec deux alias `dark` et `light` on garde le même comportement.
- Offrir une liste de thème dans laquelle piocher.
- Ne pas s'arrêter à modifier le thème. On peut faire pareil pour la police, l'opacité, etc.

Par contre `sed` à tendance à être un peu cryptique ;) Et de plus je ne suis pas
convaincu que modifier directement le fichier de config soit une bonne chose.
Alors j'ai pensé à une autre méthode.

## Idée n°2 - configuration déportée

Je vais utiliser la capacité d'importation de fichier dans toml pour ne pas
avoir à toucher au fichier de config principal. Je fais un copier/coller d'un
thème, que je vais nommer `current` :

{% highlight bash %}
$ cp ~/.config/alacritty/themes/autumn.toml ~/.config/alacritty/themes/current.toml
{% endhighlight %}

Et je modifie le fichier de config principal d'Alacritty (dans ~/.alacritty.toml)
pour utiliser ce "nouveau" thème :

{% highlight toml %}
[general]
import = [
  "~/.config/alacritty/themes/current.toml",
]
{% endhighlight %}

Pour changer de thème, plus besoin de toucher au fichier de config
principal, il suffit de modifier le thème que j'ai appelé `current`.
Par exemple :

{% highlight bash %}
$ cp ~/.config/alacritty/themes/ashes_light.toml ~/.config/alacritty/themes/current.toml
{% endhighlight %}

Sauf que maintenant, le _live_reload_ ne fonctionne plus puisqu'on n'a pas
touché au fichier de config. Pour remédier à cela il suffit de faire croire à
Alacritty que la config a été modifiée et le tour est joué :

{% highlight bash %}
$ touch ~/.alacritty.toml
{% endhighlight %}

Comme pour la méthode précédente, on pourra faire des commandes pour le shell.
Par exemple :

fichier light
{% highlight bash %}
#!/bin/bash
cp ~/.config/alacritty/themes/ashes_light.toml ~/.config/alacritty/themes/current.toml
touch ~/.alacritty.toml
{% endhighlight %}

fichier dark
{% highlight bash %}
#!/bin/bash
cp ~/.config/alacritty/themes/autumn.toml ~/.config/alacritty/themes/current.toml
touch ~/.alacritty.toml
{% endhighlight %}

## Fichier de configuration de notre _theme switcher_

Je n'ai pas envie de modifier les fichiers des commandes `light` et `dark`
chaque fois que j'aurais envie de tester des nouveaux thèmes. Alors franchissons
un pas en offrant un fichier de config à notre _theme switcher_ ;)

Il s'appelera `switcher.config` et sera placé dans le même dossier que tout les
thèmes. Ça m'évitera de le chercher.

Avec Bash :
{% highlight bash %}
light_name = "ashes_light"
dark_name = "autumn"
{% endhighlight %}

Avec Fish :
{% highlight bash %}
set light_name "ashes_light"
set dark_name "autumn"
{% endhighlight %}

Et pour finir voici comment l'utiliser dans une commande Bash et/ou Fish :

fichier light
{% highlight bash %}
#!/bin/fish
set dir ~/.config/alacritty/themes
source $dir/switcher.config
cp $dir/$light_name.toml $dir/current.toml
touch ~/.alacritty.toml
{% endhighlight %}

Et comment l'utiliser dans une fonction Fish :

{% highlight bash %}
function light \
  --description 'Set alacritty light theme'

  set dir ~/.config/alacritty/themes
  source $dir/switcher.config
  cp $dir/$light_name.toml $dir/current.toml
  touch ~/.alacritty.toml
end
{% endhighlight %}

## Une dernière remarque

Ici le changement de thème dans Alacritty est juste un pretexte. Ces méthodes
pourront être utilisées pour modifier les configurations d'à peu près n'importe quoi.
