---
layout: post
title: "Un plugin Octopress pour les articles connexes"
date: 2013-08-22 15:56
comments: true
categories: [octopress, plugin, débutant, ruby]
---

{% level 1 %}

Je cherchais un plugin Octopress pour embarquer une section d'articles
connexes (*related posts*) dans certains articles et, curieusement, je
n'en ai pas trouvé. C'est donc l'occasion d'écrire mon second plugin pour
Octopress.

<!-- more -->

Pour voir ce que fait ce plugin, il vous suffit de regarder la section
«Articles connexes» à la fin de cet article. Le code est sur Github:
[octopress-connexe](https://github.com/lkdjiin/octopress-connexe).

Je vais commenter quelques unes des méthodes:

``` ruby
def my_categories(context)
  context.environments.first["page"]["categories"]
end

def my_url(context)
  context.environments.first["page"]["url"]
end
```

J'ai séché un certain temps là-dessus. Pour connaitre les informations
relative à l'article courant, on se sert de
`context.environments.first["page"]`.

Et voici comment je fais la sélection des articles connexes:

``` ruby
def build_posts(context)
  remove_unrelated_posts
  remove_current_post(context)
  sort_posts
end

def remove_unrelated_posts
  @posts = @posts.select do |post|
    result = false
    @categories.each do |category|
      result = true if post.categories.include?(category)
    end
    result
  end
end

def remove_current_post(context)
  @posts.delete_if {|post| post.url == my_url(context)}
end

def sort_posts
  @posts = @posts.map do |post|
    weight = 0
    @categories.each do |category|
      weight += 1 if post.categories.include?(category)
    end
    [weight, post]
  end
  @posts = @posts.sort.reverse
end
```

Dans un premier temps, j'écarte les articles qui n'ont pas au moins
une catégorie commune avec l'article courant. C'est le rôle de la méthode
`remove_unrelated_posts`. Puis après avoir écarter de la liste l'article
courant, il ne reste plus qu'à trier avec la méthode `sort_posts`. Dans cette
méthode, j'attribue un poid à chaque article en fonction du nombre de
catégories communes. C'est ce poid qui sert de référence pour le tri.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
