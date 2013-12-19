---
layout: post
title: "Comment écrire un plugin Octopress - partie 2"
date: 2013-07-30 08:18
comments: true
categories: [octopress, plugin, ruby, débutant]
---

{% level 1 %}

Dans [la première partie](http://lkdjiin.github.io/blog/2013/07/27/comment-ecrire-un-plugin-octopress/),
je m'étais arrêté sur le code suivant:

``` ruby
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
```

Aujourd'hui je montre comment permettre à l'utilisateur de personnaliser
le contenu du code Html produit.

<!-- more -->

Tout d'abord, voici le code du plugin terminé. Je vous rappelle que vous
pouvez trouver [ce plugin sur Github](https://github.com/lkdjiin/octopress-level-tag).

``` ruby
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
```

L'appel du plugin dans les articles sera maintenant réalisé comme ceci:

``` ruby
{% level 1 %}
```

Par rapport à la première version, la méthode `render` a bien enflée. -
*Je trouve qu'il y a trop de code dedans, mais ce sera peut-être le sujet
d'un prochain article sur le refactoring.* - C'est cette méthode qui fait
tout le travail, voici les explications:

``` ruby
    def render(context)
      config = context.registers[:site].config
      label = config['level_tag_level'] || "Level: "
```

C'est l'objet `context` qui va permettre de récupérer les informations
nécéssaires dans le fichier de configuration `_config.yml`. Voici par
exemple ce que j'ai ajouté dans mon `_config.yml`:

``` yaml
# LevelTag plugin
level_tag_level: "Niveau : "
level_tag_level_1: "facile"
level_tag_level_2: "intermédiaire"
level_tag_level_3: "avancé"
```

La ligne suivante:

    label = config['level_tag_level'] || "Level: "

initialise la
variable `label` avec le contenu de `level_tag_level`, trouvé dans le
`_config.yml`. La partie du code `|| "Level: "` est là pour s'assurer que
si `level_tag_level` n'existe pas dans le fichier de configuration, `label`
sera bien initialisé avec une valeur par défaut.


``` ruby
      level = case @level
      when "1" then config['level_tag_level_1'] || "easy"
      when "2" then config['level_tag_level_2'] || "medium"
      when "3" then config['level_tag_level_3'] || "hard"
      else
        "unknown"
      end
```

C'est la même logique que précédement. La variable `level` sera initialisée
avec du contenu trouvé dans `_config.yml` ou bien, avec une valeur par
défaut.

``` ruby
      classes = "class='level-tag level-tag-#{@level}'"
      "<div #{classes}>#{label}<span>#{level}</span></div>"
```

Finalement, comme dans [la première partie](http://lkdjiin.github.io/blog/2013/07/27/comment-ecrire-un-plugin-octopress/),
on retrouve en fin de méthode la production du code Html.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
