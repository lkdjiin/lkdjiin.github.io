---
layout: post
title: "Prise en main de la gem chunky_png"
date: 2013-11-07 17:32
comments: true
categories: [ruby, gem, imagerie, png, débutant]
---

{% level 1 %}

Pour un projet j'ai besoin de manipuler du format png et j'ai décidé
d'utiliser la gem `chunky_png` pour faire ça. Comme je ne la connais pas,
j'écris aujourd'hui une rapide prise en main de cette gem, histoire de me
familiariser avec.

Pour l'installer, c'est comme d'habitude:

    gem install chunky_png

<!-- more -->

Pour la documentation on pourra commencer par [le wiki](https://github.com/wvanbergen/chunky_png/wiki) du projet.

La première chose que je veux faire c'est lire et écrire un fichier png.

``` ruby test.rb
require "chunky_png"

image = ChunkyPNG::Image.from_file(ARGV[0])
image.save("copy.png")
```

Après l'avoir lancé, ce programme crée une copie de l'image originale sous le
nom "copy.png":

    [~]⇒ ruby test.rb test.png 

Super, bon début. Maintenant je voudrais accéder à la valeur RGB d'un pixel
quelconque de l'image. Voici le second programme:

``` ruby test2.rb
require "chunky_png"

image = ChunkyPNG::Image.from_file(ARGV[0])

p ChunkyPNG::Color.r(image[0, 0])
p ChunkyPNG::Color.g(image[20, 20])
p ChunkyPNG::Color.b(image[40, 40])
p ChunkyPNG::Color.to_hex(image[60, 60])
p ChunkyPNG::Color.to_truecolor_bytes(image[80, 80])
```

Et un exemple de sortie possible:

    [~]⇒ ruby test2.rb test.png 
    255
    255
    255
    "#000000ff"
    [0, 0, 0]

L'image est vue comme un tableau à 2 dimensions: `image[x, y]`.
Les méthodes `r`, `g` et `b` renvoient respectivement la composante rouge,
verte ou bleue du pixel. La méthode `to_hex` formate *à la HTML* et la
méthode `to_truecolor_bytes` renvoie un tableau des trois composantes RGB.

J'aimerais maintenant dessiner un rectangle dans l'image:

``` ruby test3.rb
require "chunky_png"

image = ChunkyPNG::Image.from_file(ARGV[0])
image.rect(0, 0, 99, 99)
image.save("copy.png")
```

Si vous lancez ce programme (avec `ruby test3.rb test.png`), vous verrez
qu'il dessine bien un rectangle (x = 0, y = 0, largeur = 99, hauteur = 99).
Malheureusement, seul le *contour* du rectangle est dessiné.
Pour dessiner un rectangle rempli, il en faut un peu plus:

``` ruby test4.rb
require "chunky_png"

my_color = ChunkyPNG::Color.rgb(10, 100, 200)

image = ChunkyPNG::Image.from_file(ARGV[0])
image.rect(0, 0, 99, 99, my_color, my_color)
image.save("copy.png")
```

Cette fois on a bien un rectangle *rempli*. Et au passage on voit comment
définir une couleur au format RGB.

Pour finir, je voudrais créer une image:

``` ruby test5.png
require "chunky_png"

image = ChunkyPNG::Image.new(400,
                             400,
                             ChunkyPNG::Color::WHITE)

my_color = ChunkyPNG::Color.rgb(10, 100, 200)
my_color2 = ChunkyPNG::Color.rgb(110, 10, 100)

image.rect(0, 0, 199, 199, my_color, my_color)
image.rect(200, 200, 399, 399, my_color2, my_color2)

image.save("new.png")
```

Le programme se lance avec `ruby test5.rb` et crée une nouvelle image `new.png`.
Le constructeur de `Image` prend tout simplement la largeur, la hauteur et
la couleur de fond de l'image.

En bref, `chunky_png` est une gem qui a l'air simple a utiliser.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

