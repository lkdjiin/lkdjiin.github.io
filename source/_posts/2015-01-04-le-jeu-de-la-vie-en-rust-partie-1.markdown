---
layout: post
title: "Le jeu de la vie en Rust - partie 1"
date: 2015-01-04 18:04
comments: true
categories: [jeu de la vie, rust]
---

{% level 1 %}

Premiers pas avec Rust
----------------------

On va écrire une version simple du jeu de la vie en Rust.

### Installer Rust

Rendez-vous [sur cette page](http://www.rust-lang.org/install.html) pour trouver
le type d'installation qui vous convient. Même si on peut trouver que cela pose
des problèmes, j'ai opté pour la méthode la plus simple:

    $ curl -s https://static.rust-lang.org/rustup.sh | sudo sh

Cela installe la version *nightly* et le gestionnaire de paquet `Cargo`.
L'installation est très rapide.

Pour information, voici la version que j'ai installé:

    $ rustc --version
    rustc 0.13.0-nightly (636663172 2014-12-28 16:21:58 +0000)

<!-- more -->

### Cargo

Rust fournit un outil très proche du Bundler des rubyistes, il s'agit
de Cargo. On s'en sert pour la création d'un projet, faire les builds,
lancer les tests, gérer les dépendances, etc…

Je crée le projet `game_of_life`:

    $ cargo new game_of_life --bin
    $ cd game_of_life

Ça donne ceci:

    $ tree
    .
    ├── Cargo.toml
    └── src
        └── main.rs

Le fichier `Cargo.toml` est un manifeste et ne nous intéresse pas trop pour
l'instant.

### Création d'une génération de cellules

Je ne vais pas parler de test aujourd'hui, ça sera pour plus tard. Je vais seulement écrire une
fonction `create_generation` (ma toute première fonction Rust !) qui va produire un tableau de
cellules, c'est à dire un tableau de 0 et de 1.

Pour représenter une génération, j'ai déjà utilisé dans les articles précédents des tableaux de
tableaux et des tableaux à 2 dimensions. C'est ma dernière chance d'utiliser des tableaux plats.
Voici le code complet du fichier `main.rs`.

``` rust src/main.rs
use std::rand::Rng;

fn main() {
    let gen = create_generation(3, 4);
    println!("{}", gen);
}

fn create_generation(width: uint, height: uint) -> Vec<uint> {
    let size = width * height;
    let mut result = Vec::new();
    for _ in range(0u, size) {
        let cell = std::rand::task_rng().gen_range(0u, 2u);
        result.push(cell);
    }
    result
}
```

Pour le compiler et le lancer, on peut utiliser Cargo:

    $ cargo run
         Running `target/game_of_life`
    [1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0]

Je ne suis pas très content de cette fonction `create_generation`, j'ai bien
conscience qu'elle est maladroite, mais elle a
au moins un mérite: elle fonctionne ! Alors, place aux explications.

    fn create_generation(width: uint, height: uint) -> Vec<uint> {

Rust est statiquement typé, le compilateur doit connaître la signature d'une
fonction. Donc on déclare le type des paramêtres (ici `uint` pour *unsigned int*)
et le type de la valeur de retour (ici un `Vec`teur).

    let size = width * height;

On déclare une variable avec `let`. Pas besoin de préciser le type de `size`
puisque le compilateur peut l'inférer.

    let mut result = Vec::new();

Par défaut, une variable ne peut pas être modifiée, comme je désire ajouter des
éléments à `result`, je dois spécifier `mut` (pour *mutable*).

    for _ in range(0u, size) {
        let cell = std::rand::task_rng().gen_range(0u, 2u);
        result.push(cell);
    }

`0u` est une autre manière de préciser le type. Ici c'est `0` de type `uint`.
Dans la boucle on génère un nombre aléatoire et on l'ajoute dans `result`.

    result

Finalement on renvoie `result`. Notez qu'il n'y a pas de point-virgule après
`result`, c'est voulu, ça ne fonctionnerait pas avec. Par contre j'aurais pu
écrire `return result;`, et là il faudrait le point-virgule. Je n'ai pas encore
très bien compris le pourquoi du comment, donc je ne vais pas me risquer à vous
fournir une explication foireuse.

Voilà, c'est tout pour ma première approche de Rust. La prochaine fois je
parlerais des tests unitaires.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
