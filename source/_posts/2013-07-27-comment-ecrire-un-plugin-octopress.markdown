---
layout: post
title: "Comment écrire un plugin Octopress"
date: 2013-07-27 12:56
comments: true
categories: [octopress, plugin, ruby, débutant]
---

{% level 1 %}

Pour mon blog Octopress, je voulais un repère visuel qui marque le niveau de
difficulté des articles. Un truc comme «Niveau : débutant» ou bien «Niveau :
confirmé» avec un peu de couleur. Rien de bien compliqué en fait. Si passer par
l'écriture d'un plugin pour obtenir ce genre d'effet n'est pas absolument
neccéssaire, ça rendra l'écriture des articles plus agréable et plus
rapide. Et puis je vais apprendre quelque chose de nouveau : comment écrire
un plugin pour Octopress ?

<!-- more -->

Tout d'abord, le site d'Octopress ne propose pas de documentation sur
l'écriture de plugins. Par contre, le wiki fournit 
[une longue liste de plugins](https://github.com/imathis/octopress/wiki/3rd-party-plugins)
 dont les sources sont les bienvenues. Jekyll, le programme sur lequel est
construit Octopress, est assez spartiate en ce qui concerne
[l'écriture de plugin pour Jekyll](http://jekyllrb.com/docs/plugins/). Malgré
tout, ce lien peut s'avérer utile. J'ai trouvé que la meilleure source
d'information pour commencer est le contenu du dossier `plugin` de votre
blog Octopress.

Si vous voulez tout de suite jetez un coup d'oeil sur le
[code source du plugin](https://github.com/lkdjiin/octopress-level-tag/releases)
terminé, vous pouvez le trouver sur Github, à la version 0.1.0.

Démarront avec le plugin le plus simple auquel je puisse penser. Créer un
fichier `plugins/level_tag.rb` et placez y le contenu suivant:

``` ruby plugins/level_tag.rb
module Jekyll
  class LevelTag < Liquid::Tag

    def render(context)
      "Niveau : facile"
    end

  end
end
Liquid::Template.register_tag('level', Jekyll::LevelTag)
```

Ensuite, dans un post, appelez le plugin de cette façon:

``` ruby
{% level %}
```

Puis lancez Octopress:

    rake generate
    rake preview

Pointez votre navigateur sur `localhost:4000` et voilà. Un beau label
«Niveau : facile» apparait dans votre post. Voyons maintenant comment ça
marche.

``` ruby
module Jekyll
  class LevelTag < Liquid::Tag
```

Un plugin pour Octopress est avant tout un plugin pour Jekyll.
Et Jekyll se sert du 
[moteur de template Liquid](http://rubydoc.info/gems/liquid). Notre classe
`LevelTag` va donc hériter de `Liquid::Tag`, et être placée dans le
module Jekyll. La classe `Liquid::Tag` nous offre tout ce qu'il faut
pour générer du html, récupérer des arguments, etc.

``` ruby
    def render(context)
      "Niveau : facile"
    end
```

La seule méthode de `Liquid::Tag` qu'il faut absolument implémenter est
`render`. C'est elle qui va produire le code html qui sera placé dans
notre article, à la place de l'appel du plugin.

``` ruby
Liquid::Template.register_tag('level', Jekyll::LevelTag)
```

Finalement, il faut enregistrer notre plugin auprès de `Liquid::Template`.
Le premier argument passé à `register_tag` est le nom sous lequel nous
voulons appeler le plugin dans nos articles. Le second argument est la
classe de notre plugin.

Pour aller plus loin, il va falloir passer des arguments depuis l'appel du
plugin jusqu'à notre classe `LevelTag`. On change donc l'appel ainsi:

``` ruby
{% level facile %}
```

Et on transforme le plugin de cette façon:

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

Voyons les changements en détails.

``` ruby
    def initialize(tagname, level, tokens)
      @level = level
    end
```

La variable `level` va contenir l'argument passé lors de l'appel du
plugin (`facile`), donc `level == 'facile'`. On sauvegarde
cette valeur dans un membre pour pouvoir la réutiliser plus tard.

``` ruby
    def render(context)
      "Niveau : #{@level}"
    end
```

Grâce à `@level` on a les moyens de faire sortir à `render` l'argument
passé lors de l'appel du plugin.

Comme certains voudront «Niveau : facile» et d'autres voudront
«Niveau : débutant», il va nous falloir un moyen de personnaliser tout ça.
C'est ce qu'on découvrira dans un prochain numéro.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
