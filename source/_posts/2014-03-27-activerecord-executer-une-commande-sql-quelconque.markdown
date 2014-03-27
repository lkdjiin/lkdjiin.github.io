---
layout: post
title: "ActiveRecord - Executer une commande SQL quelconque"
date: 2014-03-27 20:59
comments: true
categories: [ruby, activerecord, sql, intermédiaire]
---

{% level 2 %}

Chaque SGBD (Systême de Gestion de Base de Données), comme postgresql ou
mysql par exemple, définissent des tables avec des infos très
intéressantes (appelées meta-data, shéma, catalogue, etc.).

Ces *méta-données* ne sont pas reliées à un modèle ActiveRecord, alors
comment y accéder si vous en avez besoin ?

<!-- more -->

En utilisant la méthode `execute` sur la méthode `connection`:

``` ruby
sql = "ma requete SQL"
result = ActiveRecord::Base.connection.execute(sql)
```

`result` possède maintenant les lignes dont vous aviez tant besoin:

``` ruby
result.each do |row|
  puts row
end
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

