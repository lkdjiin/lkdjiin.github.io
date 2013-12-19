---
layout: post
title: "Je veux mon blog Octopress en français"
date: 2013-07-13 07:19
comments: true
categories: [octopress, ruby, internationalization, localization]
---

{% level 1 %}

Octopress n'est pas prévu pour être internationnalisé et localisé. C'est
comme ça. Je ne pense pas que ça change avant un moment, si jamais ça
change. Suite à une
[conversation sur twitter](https://twitter.com/lkdjiin/status/355699071895343105)
avec @octopress, on m'a
conseillé de regarder du coté de Jekyll. Je le ferais surement, mais plus
tard. Je ne connais pas du tout Jekyll et je veux mon blog Octopress en
français maintenant. (Ok, je fais un caprice)

<!-- more -->

Je vais vous montrer comment j'ai fait pour internationnalisé Octopress.
Si vous en avez envie vous aussi, vous pourrez suivre cette procédure
pour ne pas vous prendre la tête à chercher vous-même.

Les titres
-------------
Les titres des articles (aussi dans le volet à droite) sont capitalisés à
l'extrème. Chaque première lettre d'un mot est en majuscule.  Alors,
capitaliser chaque mot d'un titre, ça fait cool en anglais, mais en français
c'est juste horrible et illisible. Pour arranger ça, on change la méthode
`titlecase` dans `plugins/titlecase.rb`.

``` ruby plugins/titlecase.rb
def titlecase
  capitalize
end
```

**Edit 14/07/2013** Pas besoin de faire tout ça en fait. Il suffit de passer
`titlecase:` à `false` dans le fichier `_config.yml`. Merci à Jonathan Georges
pour cette info.

Les dates
--------------
Je veux les dates en français, bien sûr. Les changements sont à faire
dans `plugins/date.rb`, et je vais vraiment y aller avec mes gros sabots.
Tout d'abord il faut modifier la méthode `ordinalize` ainsi:

``` ruby méthode ordinalize dans plugins/date.rb
# Returns an ordinal date eg 1 juillet 2007 -> 1er juillet 2007
def ordinalize(date)
  date = datetime(date)
  "#{ordinal(date.strftime('%e').to_i)} " +
  "#{french_month(date.strftime('%-m'))} " +
  "#{date.strftime('%Y')}"
end
```

Puis on modifie la méthode `ordinal` de cette façon:

``` ruby méthode ordinal dans plugins/date.rb
# Returns an ordinal number. 1 -> 1er.
def ordinal(number)
  if number.to_i == 1
    "#{number}<span>er</span>"
  else
    "#{number}"
  end
end
```

Et enfin il faut ajouter la méthode `french_month`. C'est très basique, mais ça
fonctionne:

``` ruby méthode french_month dans plugins/date.rb
# Returns a string french month. 1 -> janvier, 2 -> février, etc.
def french_month(number)
  case number.to_i
  when 1; "janvier"
  when 2; "février"
  when 3; "mars"
  when 4; "avril"
  when 5; "mai"
  when 6; "juin"
  when 7; "juillet"
  when 8; "août"
  when 9; "septembre"
  when 10; "octobre"
  when 11; "novembre"
  when 12; "décembre"
  end
end
```

Si vous êtes en Ruby 1.9.3, il ne faut pas oublier de mettre un encodage
au début du fichier, à cause des caractères accentués :

``` ruby 1ère ligne de plugins/date.rb
# -*- encoding: utf-8 -*-
```


Les chaînes de caractères embarquées
------------------------------------
Rien de bien intéressant pour cette partie, il suffit de remplacer une
chaîne par une autre. Je vais donc me contenter de dresser la liste.

* "Read on" : `_config.yml`
* "Recent Posts" : `source/_includes/aside/recent_posts.html`
* "Search" : `source/_includes/navigation.html`
* "Posted by" : `source/_includes/post/author.html`
* "posted in" : `source/_includes/archive_post.html`

### Category:
Pour remplacer «Category: » par «Catégorie : », c'est un peu différent.
Il faut *ajouter* la ligne suivante dans `_config.yml`:

```
category_title_prefix: "Catégorie : "
```


Conclusion
----------
Alors voilà, j'ai bien conscience que certaines modifications risquent ne plus
fonctionner après une mise à jour d'Octopress… Mais c'est tout ce que j'ai
trouvé pour faire ça dans l'heure.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
