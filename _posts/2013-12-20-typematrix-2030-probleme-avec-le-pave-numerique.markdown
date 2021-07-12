---
layout: post
title: "Typematrix 2030: Problème avec le pavé numérique"
date: 2013-12-20 16:06
legacy: true
tags: [astuce, typematrix, matériel]
---


Normalement, un simple appui sur la touche «num» bascule du clavier
normal vers le clavier numérique et vice-versa. Cela fonctionnait
très bien quand j'ai reçu le clavier et puis d'un jour à l'autre,
sans prévenir, plus rien…

<!-- more -->

Quand je dis «plus rien», je veux dire : l'appui sur la touche «num» met
bien en marche la petite led, mais quand tu appuis sur un chiffre, ça
marche pas.

Frustrant. Surtout quand tu met plus de 100€ dans un clavier et qu'en faisant
quelques recherches tu t'aperçois que c'est un problème récurrent et
que [le site de Typematrix](http://typematrix.com/support/user-guide.php) n'est pas très loquace sur le sujet. En gros tu ne
trouves pas la solution à ton problème (récurrent hein) sur le site du
fabriquant. Il me semble pourtant que la FAQ serait un bon endroit pour 
ça, non ?

Bref, le Typematrix 2030 gère la bascule pavé numérique/clavier normal en
interne, et pour cela, il s'attend à ce que l'ordinateur démarre en mode
«verrou numérique». Ce que font 99% des machines, dont la mienne. C'est donc
pas le problème.

La solution, [trouvée ici](http://brainstormy.wordpress.com/2011/11/29/typematrix-ez-2030-et-ubuntu-11-10/) (au passage un grand merci !),
est de décocher l'option «permettre le contrôle du pointeur en utilisant le
pavé numérique» qui, sur Debian, se trouve dans `Système>Préférences>Clavier`.

Grâce à cela, ça fonctionne de nouveau. Mais il reste toujours un mystère.
Si cette fameuse option était précédement décochée, comment s'est-elle
retrouvée cochée ? Dans le cas contraire, pourquoi le Typematrix s'est
mis soudainement à la considérer ? En conclusion, ça marche, mais je ne
sais pas vraiment pourquoi.



À demain.




