---
layout: post
title: "Le format JSON et les caractères de fin de lignes"
date: 2014-03-18 21:28
legacy: true
tags: [json, ruby, parsing, débutant]
---



Dans un fichier au format JSON, on ne met pas tout ce qu'on veut…
Notamment en ce qui concerne les caractères de fin de ligne et les
tabulations.

<!-- more -->

En effet, ceux-ci ne sont pas autorisés à l'intérieur des chaines de
caractères. Voici un exemple.

Tout d'abord, pas de caractères spéciaux:

{% highlight json %}
{
  "item" : "article"
}
{% endhighlight %}

{% highlight irb %}
$ rvm use 2.1.0
Using /home/xavier/.rvm/gems/ruby-2.1.0
$ irb
>> require 'json'
=> file = IO.read File.expand_path('./doc.json')
>> JSON.parse file
=> {"item"=>"Article"}
{% endhighlight %}

Tout va bien.

Maintenant avec des caractères de fin de lignes échappés:

{% highlight json %}
{
  "item" : "article\ndescription\nprice"
}
{% endhighlight %}

{% highlight irb %}
=> file = IO.read File.expand_path('./doc.json')
=> "{\n  \"item\" : \"article\\ndescription\\nprice\"\n}\n"
>> JSON.parse file
=> {"item"=>"article\ndescription\nprice"}
{% endhighlight %}

C'est toujours bon.

Par contre, avec des fins de lignes «en dur» dans le fichier:

{% highlight json %}
{
  "item" : "Article
    description
    price"
}
{% endhighlight %}

{% highlight irb %}
>> file = IO.read File.expand_path('./doc.json')
=> "{\n  \"item\" : \"Article\n    description\n    price\"\n}\n"
>> JSON.parse file
JSON::ParserError: 757: unexpected token at '{
  "item" : "Article
    description
    price"
}
'
{% endhighlight %}

Rien ne va plus. C'est pareil avec les tabulations.

Si vous récupérez ce genre de fichier, vous pouvez les nettoyer en
remplaçant par exemple les tabulations et les fins de ligne par un
espace:

{% highlight ruby %}
file.gsub(/[\t\n]/, ' ')
{% endhighlight %}



À demain.



