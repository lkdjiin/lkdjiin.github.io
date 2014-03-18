---
layout: post
title: "Le format JSON et les caractères de fin de lignes"
date: 2014-03-18 21:28
comments: true
categories: [json, ruby, parsing, débutant]
---

{% level 1 %}

Dans un fichier au format JSON, on ne met pas tout ce qu'on veut…
Notamment en ce qui concerne les caractères de fin de ligne et les
tabulations.

<!-- more -->

En effet, ceux-ci ne sont pas autorisés à l'intérieur des chaines de
caractères. Voici un exemple.

Tout d'abord, pas de caractères spéciaux:

``` json doc.json
{
  "item" : "article"
}
```

``` irb
$ rvm use 2.1.0
Using /home/xavier/.rvm/gems/ruby-2.1.0
$ irb
>> require 'json'
=> file = IO.read File.expand_path('./doc.json')
>> JSON.parse file
=> {"item"=>"Article"}
```

Tout va bien.

Maintenant avec des caractères de fin de lignes échappés:

``` json doc.json
{
  "item" : "article\ndescription\nprice"
}
```

``` irb
=> file = IO.read File.expand_path('./doc.json')
=> "{\n  \"item\" : \"article\\ndescription\\nprice\"\n}\n"
>> JSON.parse file
=> {"item"=>"article\ndescription\nprice"}
```

C'est toujours bon.

Par contre, avec des fins de lignes «en dur» dans le fichier:

``` json doc.json
{
  "item" : "Article
    description
    price"
}
```

``` irb
>> file = IO.read File.expand_path('./doc.json')
=> "{\n  \"item\" : \"Article\n    description\n    price\"\n}\n"
>> JSON.parse file
JSON::ParserError: 757: unexpected token at '{
  "item" : "Article
    description
    price"
}
'
```

Rien ne va plus. C'est pareil avec les tabulations.

Si vous récupérez ce genre de fichier, vous pouvez les nettoyer en
remplaçant par exemple les tabulations et les fins de ligne par un
espace:

``` ruby
file.gsub(/[\t\n]/, ' ')
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

