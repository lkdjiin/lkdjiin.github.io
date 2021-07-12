---
layout: post
title: "ActiveRecord - Executer une commande SQL quelconque"
date: 2014-03-27 20:59
legacy: true
tags: [ruby, activerecord, sql, intermédiaire]
---



Chaque SGBD (Systême de Gestion de Base de Données), comme postgresql ou
mysql par exemple, définissent des tables avec des infos très
intéressantes (appelées meta-data, shéma, catalogue, etc.).

Ces *méta-données* ne sont pas reliées à un modèle ActiveRecord, alors
comment y accéder si vous en avez besoin ?

<!-- more -->

En utilisant la méthode `execute` sur la méthode `connection`:

{% highlight ruby %}
sql = "ma requete SQL"
result = ActiveRecord::Base.connection.execute(sql)
{% endhighlight %}

`result` possède maintenant les lignes dont vous aviez tant besoin:

{% highlight ruby %}
result.each do |row|
  puts row
end
{% endhighlight %}



À demain.



