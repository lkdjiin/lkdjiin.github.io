---
layout: post
title: "Je ne vais pas terminer le jeu de la vie en Rust"
date: 2015-01-22 17:05
legacy: true
tags: [jeu de la vie, rust]
---



Je ne vais pas terminer le jeu de la vie en Rust. Si vous voulez vraiment savoir
pourquoi, continuez à lire cet article. Sinon passez au suivant qui devrait
être plus intéressant :-)

<!-- more -->

    $ rustc --version
    rustc 1.0.0-nightly (29bd9a06e 2015-01-20 23:03:09 +0000)

Après avoir procédé à la mise à jour de Rust, j'ai commencé à vouloir régler
les conflits :/ Parce que oui, même avec le petit bout de code que j'ai obtenu
jusqu'ici il y a déjà plusieurs conflits après le changement de version.  Pour
les plus simples, il suffit de renommer `uint` en `usize` et les suffixes `u`
sur les nombres entiers en `us`.

Par contre il y a d'autres erreurs qui me donnent mal à la tête d'avance, comme
par exemple:

       Compiling game_of_life v0.0.1 (file:///home/xavier/code/rust/game_of_life)
    src/main.rs:13:20: 13:39 error: unresolved name `std::rand::task_rng`
    src/main.rs:13         let cell = std::rand::task_rng().gen_range(0us, 2us);
                                      ^~~~~~~~~~~~~~~~~~~
et aussi:

    src/main.rs:7:20: 7:23 error: the trait `core::fmt::String` is not implemented for the type `collections::vec::Vec<usize>`
    src/main.rs:7     println!("{}", gen);

Comme j'ai plusieurs projets, grands et petits, en cours en ce moment, je
préfère me concentrer sur ceux qui ont une chance d'aboutir, et le jeu de la vie
en Rust ne fait clairement pas partie de mes priorités.

Je reviendrais (peut-être) à Rust après la version 1.0 finale, quand
le langage et la documentation seront suffisamment stables.

À bientôt.


