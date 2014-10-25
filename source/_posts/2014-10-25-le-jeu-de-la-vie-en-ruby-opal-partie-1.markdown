---
layout: post
title: "Le jeu de la vie en ruby (opal) - partie 1"
date: 2014-10-25 18:13
comments: true
categories: [jeu de la vie, ruby, opal]
---

{% level 2 %}

Après la [version Javascript](http://lkdjiin.github.io/blog/2014/10/16/le-jeu-de-la-vie-en-javascript-partie-1/) du jeu de la vie, je débute la version
Ruby/Opal.

<!-- more -->

Obtenir une première génération au hasard
-----------------------------------------

    $ touch app/generation.rb
    $ touch spec/generation_spec.rb
    $ tree
    .
    ├── app
    │   └── generation.rb
    └── spec
        └── generation_spec.rb

Mon premier test consiste à spécifier l'interface publique.

``` ruby generation_spec.rb
require './app/generation.rb'

describe Generation do

  before do
    @width = 4
    @height = 3
  end

  specify { expect(Generation.new(@width, @height)).to respond_to :create }

end
```

Et on le fait passer facilement.

``` ruby generation.rb
class Generation

  def initialize(width, height)
  end

  def create
  end

end
```

Un test en plus pour s'assurer que le tableau possède le bon nombre de lignes.

``` ruby generation_spec.rb
  describe '#create' do

    it 'returns an array with the right height' do
      generation = Generation.new(@width, @height).create
      expect(generation.size).to eq @height
    end

  end
```

Encore une fois, le code vient facilement.


``` ruby generation.rb
class Generation

  def initialize(width, height)
    @height = height
  end

  def create
    Array.new(@height)
  end
end
```

Même chose maintenant avec le nombre de colonnes.


``` ruby generation_spec.rb
  describe '#create' do
    ...
    it 'returns an array with the right width' do
      generation = Generation.new(@width, @height).create
      expect(generation.first.size).to eq @width
    end

  end
```

Pour faire passer ce test, on crée un tableau à deux dimensions.

``` ruby generation.rb
class Generation

  def initialize(width, height)
    @height = height
    @width = width
  end

  def create
    Array.new(@height) { Array.new(@width) }
  end
end
```

On remarque l'expression `Generation.new(@width, @height)`, en commun dans
chaque test. C'est notre premier refactoring.


``` ruby generation_spec.rb
require './app/generation.rb'

describe Generation do

  before do
    @width = 4
    @height = 3
    @generation = Generation.new(@width, @height)
  end

  specify { expect(@generation).to respond_to :create }

  describe '#create' do

    it 'returns an array with the right height' do
      expect(@generation.create.size).to eq @height
    end

    it 'returns an array with the right width' do
      expect(@generation.create.first.size).to eq @width
    end

  end

end
```

### Du hasard maitrisé

Je veux être sûr que la méthode `create` remplit bien le tableau avec soit des
`0`, soit des `1`. Pour tester ça facilement, je vais *figer* le générateur de
nombre aléatoire à l'aide de `srand`.

``` ruby generation_spec.rb
    it 'creates random cells' do
      srand(0)
      expect(@generation.create.first).to eq [0, 1, 1, 0]
    end
```

``` ruby app/generation.rb
  def create
    Array.new(@height) { Array.new(@width) { rand(2) } }
  end
```

Afficher une génération
-----------------------

C'est la partie que je crains le plus avec certains langages. Avec Javascript
par exemple, pas de problème, mais avec Haskell, Rust ou Julia je n'ai aucune
idée des bibliothèques/frameworks/wrappers à employer.

Avec Ruby le souci est ailleurs. Je considère que l'écosystème Ruby est
horrible dès qu'on touche de près ou de loin au GUI. Je vais donc tricher
quelque peu et utiliser [opal.rb](http://opalrb.org/).

La structure de l'application va bien changer :

    $ tree
    .
    ├── app
    │   ├── application.rb
    │   ├── canvas.rb
    │   └── generation.rb
    ├── build.js
    ├── Gemfile
    ├── index.html
    ├── Rakefile
    └── spec
        └── generation_spec.rb

``` ruby Gemfile
gem "opal", ">= 0.6.2"
```

``` ruby Rakefile
require 'opal'

desc "Build our app to build.js"
task :build do
  Opal::Processor.source_map_enabled = false
  env = Opal::Environment.new
  env.append_path "app"

  File.open("build.js", "w+") do |out|
    out << env["application"].to_s
  end
end
```

``` html index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>Game of Life</title>
  </head>
  <body>
    <canvas width="100" height="100" id="canvas"></canvas>
    <script src="build.js"></script>
  </body>
</html>
```

Dans `Canvas` j'écris une sorte d'adaptateur pour utiliser un `canvas`
Javascript.

``` ruby app/canvas.rb
class Canvas

  attr_reader :width, :height

  def initialize
    @canvas  = `document.getElementById('canvas')`
    @context = `#@canvas.getContext('2d')`
    @height  = `#@canvas.height`
    @width   = `#@canvas.width`
  end

  def clear
    draw_rect(0, 0, @width, @height, 'black')
  end

  def pixel(x, y)
    draw_rect(x, y, 1, 1, 'white')
  end

  private

  def draw_rect(x, y, w, h, color)
    `#@context.fillStyle = #{color}`
    `#@context.fillRect(#{x}, #{y}, #{w}, #{h})`
  end

end
```

Dans `app/application.rb` je peux maintenant afficher une génération.

``` ruby app/application.rb
require 'opal'
require 'canvas'
require 'generation'

canvas = Canvas.new
canvas.clear

generation = Generation.new(canvas.width, canvas.height)
cells = generation.create

cells.each_with_index do |line, y|
  line.each_with_index do |cell, x|
    canvas.pixel(x, y) if cell == 1
  end
end
```

Après un `rake build`, on peut lancer l'application avec `see index.html`.

La suite la prochaine fois.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
