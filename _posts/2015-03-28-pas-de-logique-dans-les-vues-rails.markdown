---
layout: post
title: "Pas de logique dans les vues Rails"
date: 2015-03-28 09:10
legacy: true
tags: [débutant, ruby, rails, vue, helper]
---



Je dis souvent aux personnes avec qui je travaille qu'introduire de la logique
dans les vues est une mauvaise idée.

Pour moi, une vue n'est pas vraiment un fichier comme les autres. C'est avant tout du
HTML, donc normalement rien de bien compliqué. Et à ce titre, j'ai rencontré beaucoup de
développeurs, certains par ailleurs très doués, pour qui les vues sont
inconsciemment les poubelles d'un projet Rails. Leurs modèles et leurs
contrôleurs sont très bien écrits, concis, testés, refactorés, parfois même
documentés ;) Mais leurs vues sont incompréhensibles et compliquées à outrance.

{% img center /images/complexity_512.jpg %}

<!-- more -->

Pourquoi ? J'explique ça surtout par le nombre de langages qui peuvent se
côtoyer au sein d'une vue&nbsp;:

- HTML
- le langage de templating
- Ruby
- parfois même du Javascript

C'est déjà assez dur de produire du bon code avec un seul
langage, alors imaginez s'il faut jongler entre trois ou quatre !

Je me suis aperçu aussi que lorsque je dis **pas de logique dans les vues Rails**
de nombreux développeurs vont acquiescer. Ils seront d'accord avec moi sur le
principe, mais ne sauront pas pour autant comment éviter d'introduire cette
logique.

Pour ne pas avoir à embarquer trop de code Ruby dans les vues (c'est une autre
manière de dire «pas de logique») Rails propose pourtant une solution simple et parfaitement intégrée :
les *helpers*. Voyons comment ça fonctionne.

## Avec logique dans les vues

Prenons une vue très simple qui va lister tous les posts d'une collection
nommée `@feed`. Nos posts contiennent uniquement un corps de texte, nommé
`body`&nbsp;:

{% highlight erb %}
# app/views/posts/index.html.erb
<% @feed.each do |post| %>
  <p class='post-body'>
    <%= post.body %>
  </p>
<% end %>
{% endhighlight %}

Maintenant votre produit évolue : les posts peuvent contenir une photo, ou non.
Et le texte d'un post **avec** photo doit s'afficher différemment du texte d'un
post **sans** photo. On pourrait faire comme ça&nbsp;:

{% highlight erb %}
# app/views/posts/index.html.erb
<% @feed.each do |post| %>
  <p class='post-body <%= post.post_type %>'>
    <%= post.body %>
  </p>
  <% if post.photo? %>
    <%= image_tag "photos/#{post.filename}", alt: post.filename,
        class: 'photo' %>
  <% end %>
<% end %>
{% endhighlight %}

Bien sûr ça va fonctionner. Et cette première version n'est pas si mauvaise.
Mais le fait d'avoir mis un simple `if` ici fait que
la semaine prochaine nous aurons un second `if`, dans 15 jours on ajoutera un
`else`, puis dans 1 mois un `if` imbriqué avec une condition complexe, etc.

## Sans logique dans les vues

Qu'est-ce qu'on veut vraiment, du point de vue de la vue ?
On veut afficher une photo. C'est tout&nbsp;:

{% highlight erb %}
# app/views/posts/index.html.erb
<% @feed.each do |post| %>
  <p class='post-body <%= post.post_type %>'>
    <%= post.body %>
  </p>
  <%= photo_for(post) %>
<% end %>
{% endhighlight %}

On a pas besoin d'en écrire plus dans la vue. Le code Ruby, la logique, ira
dans un *helper*&nbsp;:

{% highlight ruby %}
module postsHelper

  def photo_for(post)
    if post.photo?
      path = "photos/#{post.filename}"
      image_tag(path, alt: post.filename, class: 'photo')
    end
  end

end
{% endhighlight %}

Quand le post n'est pas une photo, la méthode `photo_for` renverra `nil`, valeur
qui ne sera pas affichée dans la vue.


