---
layout: post
title: "Installer Scheme"
date: 2013-10-31 18:50
comments: true
categories: [scheme, racket, débutant]
---

Avant d'apprendre Scheme, il faut l'installer. Avant de l'installer, il
faut choisir une implémentation: interpréteur ou compilateur ? Les deux ?
Quel OS ? Quel(s) dialecte(s) ? Le site
[community.schemewiki.org](http://community.schemewiki.org/?scheme-faq-standards#implementations)
recense 75 implémentations ! Oui, j'ai compté.

<!-- more -->

Après prises de conseils et réflexion, j'ai décidé d'essayer trois
implémentations:
[Guile](http://www.gnu.org/software/guile/),
[Chicken](http://www.call-cc.org/)
et [Racket](http://racket-lang.org/).
**Guile** parce qu'il est déjà installé sur ma machine.
**Chicken** pour son compilateur vers
le langage C. **Racket** pour ses nombreux DSL, parce qu'il a l'air très cool
pour créer de nouveaux DSL et parce qu'il semble être le plus utilisé.

Guile
------

Guile semble être déjà installé sur la plupart des Linux. En tout cas, il
l'était sur ma machine…
Le REPL n'utilise pas readline par défaut, ce qui est d'ailleurs le cas
des 3 implementations que j'ai testé.
Pour activer readline, il faut créer un fichier `.guile` dans le `home` et y mettre:

``` scheme .guile
(use-modules (ice-9 readline))
(activate-readline)
```

Chicken
-------

J'ai installé Chicken grâce aux paquets Debian, rien à dire… Pour activer
readline dans le REPL, il faut d'abord installer une bibliothèque (un *egg*
dans le jargon Chicken):

    sudo chicken-install readline

Ensuite on crée un fichier `~/.csirc` avec le contenu suivant:

``` scheme .csirc
(use readline)
(current-input-port (make-gnu-readline-port))
(gnu-history-install-file-manager
 (string-append (or (get-environment-variable "HOME") ".") "/.csi.history"))
```

Enfin on crée le fichier d'historique:

    touch ~/.csi.history

Racket
------

Je voulais la toute dernière version, j'ai donc téléchargé les sources et
lancé une compilation. Tout a très bien fonctionné, le fichier `README` est
parfaitement clair. Pour activer readline dans le REPL de Racket, il faut
cette fois créé un fichier `~/.racketrc` avec le texte suivant:

``` scheme .racketrc
(require xrepl)
```



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

