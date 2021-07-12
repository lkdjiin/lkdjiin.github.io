---
layout: post
title: "Comment écrire un plugin Octopress - partie 2"
date: 2013-07-30 08:18
legacy: true
tags: [octopress, ruby]
---



Dans [la première partie](http://lkdjiin.github.io/blog/2013/07/27/comment-ecrire-un-plugin-octopress/),
je m'étais arrêté sur le code suivant:

{% highlight ruby %}
module Jekyll
  class LevelTag < Liquid::Tag

    def initialize(tagname, level, tokens)
      @level = level
    end

    def render(context)
      "Niveau : #{@level}"
    end

  end
end
Liquid::Template.register_tag('level', Jekyll::LevelTag)
{% endhighlight %}

Aujourd'hui je montre comment permettre à l'utilisateur de personnaliser
le contenu du code Html produit.

<!-- more -->

Tout d'abord, voici le code du plugin terminé. Je vous rappelle que vous
pouvez trouver [ce plugin sur Github](https://github.com/lkdjiin/octopress-level-tag).

{% highlight ruby %}
module Jekyll
  class LevelTag < Liquid::Tag

    def initialize(tagname, level, tokens)
      @level = level.strip
    end

    def render(context)
      config = context.registers[:site].config
      label = config['level_tag_level'] || "Level: "
      level = case @level
      when "1" then config['level_tag_level_1'] || "easy"
      when "2" then config['level_tag_level_2'] || "medium"
      when "3" then config['level_tag_level_3'] || "hard"
      else
        "unknown"
      end
      classes = "class='level-tag level-tag-#{@level}'"
      "<div #{classes}>#{label}<span>#{level}</span></div>"
    end

  end

end
Liquid::Template.register_tag('level', Jekyll::LevelTag)
{% endhighlight %}

L'appel du plugin dans les articles sera maintenant réalisé comme ceci:

{% highlight ruby %}

{% endhighlight %}

Par rapport à la première version, la méthode `render` a bien enflée. -
*Je trouve qu'il y a trop de code dedans, mais ce sera peut-être le sujet
d'un prochain article sur le refactoring.* - C'est cette méthode qui fait
tout le travail, voici les explications:

{% highlight ruby %}
    def render(context)
      config = context.registers[:site].config
      label = config['level_tag_level'] || "Level: "
{% endhighlight %}

C'est l'objet `context` qui va permettre de récupérer les informations
nécéssaires dans le fichier de configuration `_config.yml`. Voici par
exemple ce que j'ai ajouté dans mon `_config.yml`:

{% highlight yaml %}
# LevelTag plugin
level_tag_level: "Niveau : "
level_tag_level_1: "facile"
level_tag_level_2: "intermédiaire"
level_tag_level_3: "avancé"
{% endhighlight %}

La ligne suivante:

    label = config['level_tag_level'] || "Level: "

initialise la
variable `label` avec le contenu de `level_tag_level`, trouvé dans le
`_config.yml`. La partie du code `|| "Level: "` est là pour s'assurer que
si `level_tag_level` n'existe pas dans le fichier de configuration, `label`
sera bien initialisé avec une valeur par défaut.


{% highlight ruby %}
      level = case @level
      when "1" then config['level_tag_level_1'] || "easy"
      when "2" then config['level_tag_level_2'] || "medium"
      when "3" then config['level_tag_level_3'] || "hard"
      else
        "unknown"
      end
{% endhighlight %}

C'est la même logique que précédement. La variable `level` sera initialisée
avec du contenu trouvé dans `_config.yml` ou bien, avec une valeur par
défaut.

{% highlight ruby %}
      classes = "class='level-tag level-tag-#{@level}'"
      "<div #{classes}>#{label}<span>#{level}</span></div>"
{% endhighlight %}

Finalement, comme dans [la première partie](http://lkdjiin.github.io/blog/2013/07/27/comment-ecrire-un-plugin-octopress/),
on retrouve en fin de méthode la production du code Html.





À demain.


