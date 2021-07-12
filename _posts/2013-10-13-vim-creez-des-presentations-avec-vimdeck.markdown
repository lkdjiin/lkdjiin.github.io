---
layout: post
title: "Vim: Créez des présentations avec Vimdeck"
date: 2013-10-13 13:17
legacy: true
tags: [vim, ruby, markdown]
---

Vimdeck est un programme écrit en Ruby qui transforme un fichier texte au
format Markdown en plusieurs *slides* pour effectuer une présentation avec
l'éditeur de texte Vim !

<!-- more -->

Installation
------------

Installez tout d'abord le plugin Vim [SyntaxRange](https://github.com/vim-scripts/SyntaxRange).

Ensuite, installez le programme de manière classique:

    gem install vimdeck

Note: J'ai eu un problème de dépendance (sur Debian) et il a fallu installer la
librairie systême `libmagickwand-dev` pour que tout fonctionne bien.

Utilisation
-----------

Maintenant on écrit notre présentation au format Markdown, par exemple:

    # Premier slide

    - Premier point
    - Second point
    - Troisième point


    # Deuxième slide

    - Premier
    {~- Deuxième point~}
    {~- Troisième point~}


    # Troisième et dernier slide

    ```ruby
    class Foo
      def bar
        puts "Hello Vimdeck!"
      end
    end
    ```

Et on lance la présentation ainsi:

    vimdeck mon_fichier.md

Ensuite, on change de slide avec les touches PageUp/PageDown.

Vous pouvez voir des captures d'écrans sur le [site du projet](https://github.com/tybenz/vimdeck).

Conclusion
----------

Bon, le projet est un peu jeune et pas mal buggé, mais l'idée est vraiment
intéressante. C'est totalement improbable, complêtement loufoque, inutilisable
avec des graphiques, donc
rigoureusement indispensable, ne serait-ce que pour frimer devant les
collègues: «Regardez comment je fais une présentation en 3 minutes avec mon
éditeur de texte…».





À demain.



