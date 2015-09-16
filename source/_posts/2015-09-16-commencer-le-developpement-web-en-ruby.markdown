---
layout: post
title: "Commencer le développement web en Ruby"
date: 2015-09-16 15:10
comments: true
categories: [guest, ruby, web, framework, rack]
---

## `{ Guest Post }`

Grâce au framework [Ruby on Rails][rails], Ruby est maintenant très populaire pour le développement d'application web.
Ce domaine est un pleine croissance et Ruby on Rails attire beaucoup de débutants de tout horizons.

Je pense que commencer l'apprentissage d'un framework web nécessite de bien comprendre le rôle de chacun de ses composants.
Des composants, Ruby on Rails en comporte beaucoup et chacun d'entre eux répond à une problématique bien précise.
ORM, routeur, templates, controlleurs, tâches de fond et bien d'autres ; il y a de quoi se perdre.

Mon conseil à ceux qui débutent dans le domaine est de bien comprendre la raison d'être de chaque chose.
Une manière amusante de cerner les problématiques qui ont donnés naissance aux frameworks tel que Rails,
c'est de se passer complètement de ces briques. C'est à dire partir du strict minimum et ajouter, petit à petit,
les composants dont on ressent le besoin.

<!-- more -->

## Rack

[Rack][rack] est la brique de base de la plupart des frameworks web Ruby actuels. Rack est avant tout une API définissant
la manière pour un programme Ruby de prendre en charge et de répondre à une requête HTTP. Voici un exemple simple :

``` ruby
# ./config.ru

app = Proc.new do |env|
  [
    200,
    { "Content-Type" => "text/html" },
    [ "<h1>Hello world</h1>" ]
  ]
end

run app
```

Dans cet exemple, on voit que l'on declare une variable `app` à laquelle on assigne un object `Proc`.
Cet objet `app` est ensuite passé à la méthode `Rack::Builder#run` indiquant ainsi au serveur compatible
ce qu'il faut exectuter lorsqu'une requête arrivera.

Regardons de plus près comment se comporte le `Proc` ci-dessus. On voit qu'il prend un argument que l'on
appelle _l'environement Rack_. Le `Proc` retourne une _réponse Rack_ qui est un tableau contenant les
informations nécessaire à la construction de la réponse HTTP : le code de retour, les entêtes et le corps
de la reponse.

Rack ne nécessite pas d'utiliser un `Proc`. La seule contrainte est d'être un objet répondant à la méthode
`#call` prenant en argument un environement Rack et retournant une réponse Rack telle que nous venons de le voir.

### Exécuter l'application

Pour executer ce `config.ru` on peut utiliser l'outil `rackup` fourni avec la gem `rack`:

```
$ gem install rack
$ rackup config.ru
[2015-07-21 10:54:21] INFO  WEBrick 1.3.1
[2015-07-21 10:54:21] INFO  ruby 2.2.2 (2015-04-13) [x86_64-linux]
[2015-07-21 10:54:21] INFO  WEBrick::HTTPServer#start: pid=24457 port=9292
```

Cette commande va écouter sur le port 9292 et pour chaque requête appeller la méthode `#call` de l'objet `app`.

Lorsque l'on apportera es modification à notre code, il faudra bien penser à redémarrer le serveur : `CTRL-C` pour l'arrêter et le relancer avec la commande que l'on vient de voir.

### Qu'y a-t-il dans l'env

Pour voir ce qui se trouve dans l'environement je vais utiliser `JSON.pretty_generate` qui va m'afficher la variable
`env` au format JSON.

``` ruby
# ./config.ru

require "json"

app = Proc.new do |env|
  puts JSON.pretty_generate(env)
  [
    200,
    { "Content-Type" => "text/html" },
    [ "<h1>Hello world</h1>" ]
  ]
end

run app
```

Après avoir modifié le `config.ru`, il faut redémarrer le serveur.

Pour faire une requête, j'utilise [httpie][httpie] qui permet simplement d'envoyer des requêtes HTTP depuis le terminal et qui est équivalent à `curl` avec de jolies couleurs en plus. Vous pouvez utiliser le client de votre choix bien entendu. Chez moi cela donne :

```
$ http -v localhost:9292
GET / HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Host: localhost:9292
User-Agent: HTTPie/0.9.2



HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Type: text/html
Date: Tue, 21 Jul 2015 11:21:16 GMT
Server: WEBrick/1.3.1 (Ruby/2.2.2/2015-04-13)
Transfer-Encoding: chunked

<h1>Hello world</h1>
```

À l'issue de cette requête, on a bien le body `<h1>Hello world</h1>` qui s'affiche.
On remarque également que dans le terminal où notre serveur est lancé, on voit s'afficher
sur la sortie standard :

``` javascript
{
  "GATEWAY_INTERFACE": "CGI/1.1",
  "PATH_INFO": "/",
  "QUERY_STRING": "",
  "REMOTE_ADDR": "127.0.0.1",
  "REMOTE_HOST": "localhost",
  "REQUEST_METHOD": "GET",
  "REQUEST_URI": "http://localhost:9292/",
  "SCRIPT_NAME": "",
  "SERVER_NAME": "localhost",
  "SERVER_PORT": "9292",
  "SERVER_PROTOCOL": "HTTP/1.1",
  "SERVER_SOFTWARE": "WEBrick/1.3.1 (Ruby/2.2.2/2015-04-13)",
  "HTTP_HOST": "localhost:9292",
  "HTTP_CONNECTION": "keep-alive",
  "HTTP_ACCEPT_ENCODING": "gzip, deflate",
  "HTTP_ACCEPT": "*/*",
  "HTTP_USER_AGENT": "HTTPie/0.9.2",
  "rack.version": [
    1,
    3
  ],
  "rack.input": "#<Rack::Lint::InputWrapper:0x007fcac62086c0>",
  "rack.errors": "#<Rack::Lint::ErrorWrapper:0x007fcac6208698>",
  "rack.multithread": true,
  "rack.multiprocess": false,
  "rack.run_once": false,
  "rack.url_scheme": "http",
  "rack.hijack?": true,
  "rack.hijack": "#<Proc:0x007fcac6208b70@/home/n25/.gem/ruby/2.2.2/gems/rack-1.6.4/lib/rack/lint.rb:525>",
  "rack.hijack_io": null,
  "HTTP_VERSION": "HTTP/1.1",
  "REQUEST_PATH": "/",
  "rack.tempfiles": [

  ]
}
```

C'est uniquement à partir de cette variable `env` que notre application devra formuler une réponse Rack !

## De Rack au frameworks Web

Dans cette partie, essayons de trouver des solutions a de petits problèmes.
Bien sûr on n'utilisera que Rack.

Comme support nous nous mettrons dans le cas d'un réseau social très simplifié.

### Le routage

Chaque membre de notre réseau social va avoir une page qui lui est propre.
Pour y accéder nous utilisons le chemin suivant : `/members/<id>` où `<id>` sera _l'identifiant du membre_.

Avec Rack nous pouvons écrire le code suivant pour parvenir à isoler l'identifiant du membre :

``` ruby
def member(env)
  env["PATH_INFO"] =~ %r{\A/members/([A-Za-z0-9]+)\z} && $1
end
```

Cette méthode va nous permettre d'obtenir l'identifiant du membre en fonction de l'environement Rack.
On peut introduire ce code dans notre application :

``` ruby
app = Proc.new do |env|
  member_id = member(env)
  [
    200,
    { "Content-Type" => "text/html" },
    [ "<h1>Hello #{member_id}</h1>" ]
  ]
end
```

Ici on a extrait un paramètre de l'URL. Si on visite `/members/Nicolas` on verra le texte _Hello Nicolas_ s'afficher.
Par contre, si on visite `/signup`, on verra _Hello_ s'afficher seul puisque `member_id` sera égal à `nil`.

En pratique, notre réseau social va avoir besoin d'identifier des dixaines voir des centaines d'URLs différentes.
Avec ce volume, il est nécessaire de s'organiser autrement et d'associer les URLs gérée par notre application avec
le code responsable de répondre à la requête. Dans le cas ou une URL n'est pas gérée, on souhaite répondre par un code
d'erreur.

Voici un extrait de code permettant de répondre à cette problématique :

``` ruby
class ShowMember
  def self.match?(env)
    env["PATH_INFO"] =~ %r{\A/members/[A-Za-z0-9]+\z}
  end

  def self.call(env)
    member_id = env["PATH_INFO"].sub("/members/", "")
    headers = { "Content-Type" => "text/html" }
    body = "<h1>Hello #{member_id}</h1>"
    [ 200, headers, [ body ] ]
  end
end

actions = [ ShowMember ]

app = Proc.new do |env|
  action = actions.find { |action| action.match?(env) }
  action ? action.call(env) : [ 404, {}, [ "Not Found" ] ]
end
```

On voit que j'ai implicitement définit une interface : `#match?(env)` et `call(env)` pour les actions que
l'application peut réaliser. Chaque action est responsable de formuler une réponse Rack lors d'un appel à la
méthode `call` et de savoir, via `match?`, si oui ou non elle doit s'executer.

L'ensemble des frameworks web font un traitement semblable en utilisant une solution que l'on appelle le routage.
Différentes approches concernant le routage existent, voir [Roda][roda], [Sinatra][sinatra] et [Rails][rails-route].

Voici par exemple un extrait de code qui utilise Sinatra pour faire exactement ce que nous avons fait :

``` ruby
require "sinatra"

get "/members/:member_id" do
  member_id = params["member_id"]
  "<h1>Hello #{member_id}</h1>"
end
```

_Remarque_ :On voit dans cet exemple que Sinatra permet d'extraire les paramètres de l'URL automatiquement.

### Les templates

Lorsque l'on développe une fonctionnalité d'un site web, il est fréquent de le faire en deux phases.
Une phase de design où l'on va écrire HTML et CSS afin de visualiser le résultat voulu. Une autre phase
où l'on écrira le code métier qui va injecter les bonnes valeurs dans le HTML en fonction de l'action
effectuée.

Par exemple dans notre code : `"<h1>Hello #{member_id}</h1>"` on injecte la variable `member_id` dans
du HTML. De manière générale, le HTML est beaucoup plus volumineux que dans notre exemple.

Dans la vie de tout les jours, il est fréquent qu'une équipe soit en charge de la phase plus visuelle
(HTML / CSS) et une autre en charge du code métier. Il est donc fréquent de séparer ces deux composantes
de notre code.

Pour effectuer cette séparation, on a recours à des _moteurs de templates_. Ces briques logicielles vont
nous permettre de séparer notre présentation du code métier. Voici un exemple, toujours en utilisant
Rack :

``` ruby
require "erb"
require "ostruct"

module Template
  def erb(template_path, locals={})
    file_content = File.read(template_path)
    context = OpenStruct.new(locals).instance_eval { binding }
    ERB.new(file_content).result(context)
  end
end

class ShowMember
  extend Templating

  def self.call(env)
    member_id = env["PATH_INFO"].sub("/members/", "")
    headers = { "Content-Type" => "text/html" }
    body = Template.erb("template.html.erb", member_id: member_id)
    [ 200, headers, [ body ] ]
  end
end
```

``` erb
<h1>Hello <%= member_id %></h1>
```

Ici, on va utiliser `ERB` pour charger le fichier `template.html.erb`. Au sein de ce fichier,
la variable `member_id` sera injectée dans le HTML grâce à la notation `<%= ... %>`.

Les moteurs de templates sont nombreux : [erb][erb], [haml][haml], [slim][slim], [builder][builder],
[liquid][liquid] etc. Leur usage va plus loin que la simple séparation du code de présentation et
du code métier (voir les [partials][tmpl-partials], [stuctures de controle][tmpl-struct]...).

### Tester son application

Avant de continuer je vais déplacer le code de l'application du fichier `config.ru` vers `app.rb`.
Au passage, j'en profite pour extraire une classe `Router` ainsi qu'une constante `App` qui contiendra
notre application.

Les tests sont indispensables lors du développement d'une application. Tester une application Rack est
assez aisé grâce aux outils inclus dans la gem `rack-test`. Voici un exemple d'un fichier de test écrit
avec minitest :

``` ruby
# ./app_test.rb

require "minitest/autorun"
require "rack/test"

require_relative "app"

describe App do
  include Rack::Test::Methods

  describe "when the URL match no known action" do
    it "returns a 404 status code" do
      get "/unknown/path"
      last_response.status.must_equal 404
    end
  end

  describe "when the URL match the members's path" do
    it "displays the member's id" do
      get "/members/Nicolas"
      last_response.body.must_include "Nicolas"
    end
  end

  def app
    App
  end
end
```

Pour lancer les tests, la commande : `bundle exec ruby -Ilib:test *_test.rb --pride` suffit.

Le frameworks web tels que Rails instaurent des conventions et des outils par défaut pour le test
de ses applications. Les outils de tests fonctionnent également hors des frameworks comme le montre
notre exemple.

## Pour finir

En continuant sur cette lancée, on peut rencontrer d'autres problématiques comme les sessions, la persistance,
l'organisation du coe métier, le caching et bien d'autres. Il est très facile, avec un peu de recul, de créer
son propre framework ou d'utiliser un micro-framework puis d'y ajouter ses propres conventions ainsi que les
outils de son choix.

Même si ce billet s'adresse principalement aux débutants, j'espère qu'il touchera également quelques
enseignants ou mentors. Peu importe votre profil, n'hésitez pas à partager vos premiers pas avec le
développement web en Ruby ainsi que la manière dont vous l'aborderiez aujourd'hui.

[httpie]: https://github.com/jkbrzt/httpie
[rails]: http://rubyonrails.org/
[rack]: https://rack.github.io/
[sinatra]: http://www.sinatrarb.com/
[roda]: http://roda.jeremyevans.net/
[rails-route]: http://guides.rubyonrails.org/routing.html
[erb]: http://ruby-doc.org/stdlib-2.2.2/libdoc/erb/rdoc/ERB.html
[haml]: http://haml.info/
[slim]: http://slim-lang.com/
[builder]: https://github.com/jimweirich/builder
[liquid]: http://www.liquidmarkup.org/
[tmpl-partials]: http://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
[tmpl-struct]: http://www.rubydoc.info/gems/slim/frames#Control_code_-

# Qui a écrit cet article ?

{% img https://secure.gravatar.com/avatar/510312aa405bc675fc275fad7648eb1c?s=200 %}

**Nicolas Zermati**  
Software writer, building the backend of Sleekapp.io at Tigerlily
