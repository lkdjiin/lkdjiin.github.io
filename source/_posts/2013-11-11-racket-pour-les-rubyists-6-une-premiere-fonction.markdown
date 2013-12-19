---
layout: post
title: "Racket pour les rubyists 6: Une première fonction"
date: 2013-11-11 20:41
comments: true
categories: [racket, ruby, tutoriel, débutant]
---

{% level 1 %}

Grâce à ce qu'on a appris depuis [le début](http://lkdjiin.github.io/blog/2013/11/03/racket-pour-les-rubyists-definir-une-fonction/) de cette série d'articles,
il est enfin temps de traduire la méthode Ruby suivante en Racket:

``` ruby
def divisors(n)
  (1..n).select {|i| n % i == 0}
end
```

<!-- more -->

Une première fonction Racket
---------------------------
Sans plus attendre, voici une traduction en Racket, qui suit le modèle
du [dernier article](http://lkdjiin.github.io/blog/2013/11/10/racket-pour-les-rubyists-5-definitions-imbriquees/):

``` racket
(define (divisors n)
  ; Is i a divisor of n?
  (define (divisor? i)
    (= 0 (remainder n i)))
  (filter divisor? (range 1 (+ n 1))))
```

Voici la fonction en action:

    -> (divisors 1)
    '(1)
    -> (divisors 8)
    '(1 2 4 8)
    -> (divisors 17)
    '(1 17)
    -> (divisors 171)
    '(1 3 9 19 57 171)

Alors ça fait pas mal de code Racket comparé au code Ruby, mais attention de ne
pas juger le langage sur ce seul exemple. D'abord l'opérateur `..` de Ruby et
ses *blocks* permettent une syntaxe incroyablement concise, ensuite je
vous rappelle que *j'apprends* Racket, et que donc j'ai peut-être raté des
trucs…

Vous remarquez que je me suis senti obligé de commenté la fonction imbriquée
`divisor?`, ce qui n'est pas bon signe. Je suis un adepte du code court,
sous-entendu: une fonction devrait faire une seule chose. Or il me semble
qu'ici la fonction `divisors` fait trois choses:

1. Elle regarde si un nombre i est un diviseur de n.
2. Elle produit une liste de 1 à n inclus.
3. Enfin, elle produit la liste des diviseurs de n.

Donc `divisors` est un bon candidat au refactoring. Mais avant ça il va
falloir parler des tests unitaires avec Racket. Et avant de parler des
tests unitaires, il va falloir aborder la notion de module Racket. Si
ces sujets vous intéressent, restez à l'écoute de ce blog, c'est pour
bientôt.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

