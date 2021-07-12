---
layout: post
title: "Quelques trucs pour lancer Rspec"
date: 2014-03-20 21:06
legacy: true
tags: [débutant, ruby, rspec, test]
---



[Rspec](http://rspec.info/) est un framework de test très utilisé dans le monde Ruby.
Il y a bien des manières différentes de le lancer et aujourd'hui on
voit quelques options basiques qu'on peut utiliser tous les jours.

<!-- more -->

Tout d'abord, on peut lancer Rspec avec ses options par défaut:

    $ rspec spec/
    .................................................................
    Finished in 0.25958 seconds
    65 examples, 0 failures

À noter que le programme repose, comme souvent dans l'éco-système Ruby,
sur certaines conventions. Si le répertoire qui comporte vos tests est
nommé `spec`, vous pouvez vous contentez de:

    $ rspec
    .................................................................
    Finished in 0.25958 seconds
    65 examples, 0 failures

Parfois, on a envie de voir le nom des tests, plutôt que des petits points:

    $ rspec --format=documentation spec/
    Coco::Configuration
      should respond to #user_wants_to_run?
      with no config file
        should give a default threshold of 100%
        should give a default list of directories
        should give an empty default list of files to excludes
        should give false for 'single_line_report'
        #user_wants_to_run? returns true
        give false for 'show_link_in_terminal'
    [...]
    Finished in 0.08854 seconds
    65 examples, 0 failures

Nos tests doivent fonctionner en isolation, le résultat doit être le même
quel que soit l'ordre:

    $ rspec --order=random spec/
    .................................................................
    Finished in 0.08785 seconds
    65 examples, 0 failures
    Randomized with seed 8689

Vous pouvez mettre ses options, et d'autres, dans un fichier `.rspec` à la
racine de votre projet pour qu'elles deviennent les options par défaut.
Par exemple, le fichier suivant vous donnera une sortie en couleur et des
tests joués aléatoirement à chaque lancement de `rspec`:

{% highlight raw %}
--color
--order=random
{% endhighlight %}

Pour lancer les tests d'un seul fichier:

    $ rspec spec/configuration_spec.rb 
    .......................
    Finished in 0.03708 seconds
    23 examples, 0 failures

Pour lancer un seul test, ajouter le numéro de la ligne derrière le nom du
fichier:

    $ rspec spec/configuration_spec.rb:41
    Run options: include {:locations=>{"./spec/configuration_spec.rb"=>[41]}}
    Coco::Configuration
      with no config file
        #user_wants_to_run? returns true
    Finished in 0.00333 seconds
    1 example, 0 failures

Pour terminer ce *Rspec basics*, on peut désactiver un test en écrivant `xit`
à la place de `it`:

{% highlight ruby %}
    xit "should give a default threshold of 100%" do
      @config[:threshold].should == 100
    end
{% endhighlight %}



À demain.



