---
layout: post
title: "Le jeu de la vie en Rust - partie 2"
date: 2015-01-13 10:14
legacy: true
tags: [jeu de la vie, rust]
---



Tests unitaires avec Rust
-------------------------

Je vais ajouter des tests unitaires au code du dernier article. Il s'agissait
simplement d'une seule fonction pour créer une génération aléatoire de cellule.
Voici tout le code, l'implémentation et les tests dans le même fichier `src/main.rs`.

{% highlight rust %}
use std::rand::Rng;

#[cfg(not(test))]
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

#[cfg(test)]
mod tests {
    use super::create_generation;

    #[test]
    fn test_create_generation_length() {
        let result = create_generation(4, 3);
        assert_eq!(12, result.len());
    }

    #[test]
    fn test_create_generation_has_1_and_0() {
        let gen = create_generation(2, 3);
        for i in range(0u, gen.len()) {
            assert!(gen[i] < 2);
        }
    }
}
{% endhighlight %}

<!-- more -->

On lance les tests grâce à l'outil à tout faire, Cargo:

    $ cargo test
       Compiling game_of_life v0.0.1 (file:///home/xavier/code/rust/game_of_life)
         Running target/game_of_life-f45ebd9dc330e3e4

    running 2 tests
    test test::test_create_generation_has_1_and_0 ... ok
    test test::test_create_generation_length ... ok

    test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured

Concernant le code, il se comprend assez facilement de lui-même, voici tout de même quelques
éclaircissements:

{% highlight rust %}
#[cfg(not(test))]
fn main() {
{% endhighlight %}

Sans cette annotation (pardon, attribut en langage Rust) `cargo test` produirait
un avertissement assez ennuyeux, car la fonction `main` n'est pas utilisé par
les tests:

    $ cargo test
       Compiling game_of_life v0.0.1 (file:///home/xavier/code/rust/game_of_life)
    /home/.../main.rs:3:1: 6:2 warning: function is never used: `main`, #[warn(dead_code)] on by default
    /home/.../main.rs:3 fn main() {
    /home/.../main.rs:4     let gen = create_generation(3, 4);
    /home/.../main.rs:5     println!("{}", gen);
    /home/.../main.rs:6 }


{% highlight rust %}
#[cfg(test)]
mod tests
{% endhighlight %}

C'est la déclaration d'un **mod**ule nommé `tests`, avec un attribut permettant
à Rust de savoir que ce qui suit concerne des tests et ne devra pas être compilé
dans le programme final.

{% highlight rust %}
use super::create_generation;
{% endhighlight %}

On va utiliser la fonction `create_generation`, définie dans le parent du
module courant. `tests` est le module courant, le parent est créé automatiquement.

{% highlight rust %}
#[test]
{% endhighlight %}

Ceci n'est pas un commentaire, vous l'avez compris, on appelle ça un attribut. C'est une sorte d'annotation.
Ça dit à Rust que la prochaine fonction est un test et ça nous permet d'écrire des fonctions utilitaires
dans le module `tests`.


Tests unitaires et implémentation dans le même fichier
------------------------------------------------------

C'est la recommendation de Rust : placer les tests unitaires dans le même fichier
que l'implémentation. Bien sûr, les tests d'intégration ont un dossier et des
fichiers bien à eux.
L'idée est originale même si elle ne doit pas être nouvelle. Je dis que
l'idée n'est pas nouvelle parce que je l'ai environ deux ou trois fois par an.
Par contre je n'y ai jamais cru suffisamment pour tenter de l'implémenter. Rust
l'a fait et je suis très curieux de voir ce que cela va donner.

Cette façon de faire a des avantages, comme ne pas perdre de temps à
trouver les tests unitaires ou aider à rester *focus* sur ce qui doit être
testé. Mais je m'interroge quand même sur ce que cela peut poser comme problèmes à l'usage.

Ma première interrogation concerne la taille des fichiers.
Le code Rust, sans être le plus verbeux qui soit, est quand même loin de la concision.
Un exemple simple, en Rust:

{% highlight rust %}
let cell = std::rand::task_rng().gen_range(0u, 2u);
result.push(cell);
{% endhighlight %}

Le même en Ruby:

{% highlight ruby %}
result << rand(2)
{% endhighlight %}

Je ne serais pas étonné de trouver des fichiers Rust avec 200 lignes de code
d'implémentation (je vois ça régulièrement en Ruby).
Et si on respecte la [pyramide des tests](http://martinfowler.com/bliki/TestPyramid.html) on se retrouve
vite avec 3 ou 4 tests par fonction, d'où des fichiers assez imposants,
d'un bon millier de lignes.
En fouillant un peu dans le code de Rust, par exemple le fichier [json.rs](https://github.com/rust-lang/rust/blob/master/src/libserialize/json.rs),
on peut voir que je suis encore loin de la réalité (presque 4000 lignes).

Une autre interrogation concerne le refactoring. Il faut pouvoir facilement casser
un fichier en plusieurs autres, plus petits. Dans quelle mesure ce type de
«couplage» entre test et implémentation va faciliter, ou au contraire compliquer,
cette tâche ?

Bref, je trouve l'idée très séduisante en théorie, et j'attend de voir si sa mise
en pratique fonctionne. Il y a encore d'autres choses à dire sur les tests avec
Rust, et j'y reviendrais certainement dans un prochain article.

N'oubliez pas que votre opinion m'intéresse, alors si vous pensez quelque chose
de ces tests unitaires à même le code, laissez donc un commentaire.

À bientôt.


