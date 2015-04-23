---
layout: post
title: "3 réglages pour le langage R"
date: 2015-04-23 15:17
comments: true
categories: [R, débutant, réglage, prompt, console, terminal]
---

{% level 1 %}

Voici trois astuces pour régler/personnaliser le comportement de
l'environnement du langage R, en utilisant des fichiers de configuration.
*(Attention, je ne sais absolument pas si ça fonctionne sous Windows.)*

## 1) Le prompt

Pour personnaliser votre prompt dans R, ajoutez les lignes suivantes dans un
fichier `~/.Rprofile` (créez le pour l'occasion s'il n'existe pas).

``` r ~/.Rprofile
options(prompt = "R> ")
options(continue = "+  ")
```

Exemple :

    R> add2 <- function(n) {
    +    n + 2
    +  }
    R> 

<!-- more -->

## 2) La largeur de la sortie console

La largeur de la sortie console de R est de 80 caractères. Point barre !
Si votre console est plus large (100, 120, etc) R n'utilisera quand même que
80 caractères. En mettant une petite fonction dans un fichier à part
`~/.Rutils` (par exemple) et en référençant ce fichier depuis le `~/.Rprofile`,
on peut avoir quelque chose de *presque* dynamique.

``` r ~/.Rprofile
if (file.exists("~/.Rutils")) {
  source("~/.Rutils")
}
```

``` r ~/.Rutils
tryCatch({
  options(width = as.integer(system('tput cols', intern = TRUE)))
}, error = function(err) {
  write("Width set to 80.", stderr());
  options(width = 80)
})
```

Si vous redimensionnez votre console, il faut sourcer le fichier
(`source('~/.Rutils')`) pour prendre en compte la nouvelle largeur.

## 3) Le dossier des bibliothèques

Pour éviter que R vous crée un dossier `R` dans votre home, définissez vous
même un dossier pour stocker les packages, par exemple `~/local/R_libs/`.
Ensuite spécifiez le dans votre `~/.bashrc`&nbsp;:

``` bash
# Custom repo of libraries for R.
export R_LIBS=~/local/R_libs/
```

Vous connaissez d'autres trucs et astuces pour configurer R ? Dites moi ça dans
un commentaire. À bientôt.

{% connexe %}
