---
layout: post
title: "Comment étendre Git avec ses propres scripts"
date: 2013-07-17 08:03
legacy: true
tags: [git]
---



Ces derniers jours j'ai montré comment étendre les fonctionnalités
de Git à l'aide des alias (voir les 2 articles précédents). Aujourd'hui
on passe à la suite logique avec la création de nos propres scripts pour
Git.

*Ce qui suit fonctionne sur Linux et MacOS. Je ne sais pas si c'est
possible sur Windows.*

<!-- more -->

Un exemple vaut parfois mieux qu'un long discours. Alors créez donc le fichier
`git-hello` suivant:

{% highlight bash %}
#!/bin/bash

echo Hello
{% endhighlight %}

Donnez lui les droits d'exécution (`chmod +x git-hello`) et placez le dans
votre PATH. Moi je le place dans `~/bin/` et j'ajoute la ligne suivante à
`~/.bashrc`:

{% highlight bash %}
PATH=$PATH:/home/xavier/bin
{% endhighlight %}

Si vous n'êtes pas sous Linux, vous devrez adapter ces directives pour
votre OS. Une fois que c'est fait, vérifiez si tout fonctionne
correctement:

    xavier:~$ git-hello 
    Hello

Maintenant vous vous dites peut-être *«Bon d'accord, il vient d'écrire un
script bidon, et alors ? Je vois toujours pas le rapport avec Git !»*
Le fichier qu'on vient d'écrire n'est pas nommé n'importe comment. Il
commence par `git-`. C'est ce qui va permettre à la magie d'opérer:

    xavier:~$ git h[Tab]
    hello   help    hist    
    xavier:~$ git hello
    Hello

La même chose en différé live -* c'est mon dixième article sur ce blog,
je fête ça avec mon tout premier gif, je m'amuse comme je veux…* -

{% img /images/2013-07-17-1.gif %}

La règle est simple:

{% blockquote %}
Un fichier nommé `git-foo` sera vu par Git comme étant une de ses propres
commandes, nommée `foo`.
{% endblockquote %}

C'est possible grâce à l'auto complétion programmable de Bash, dont je
parlerais une prochaine fois. Si vous avez défini des alias un peu
complexe, vous auriez peut-être avantage à les placez dans un script pour
profiter de la coloration syntaxique.
Demain, je montrerais un script un
peu plus utile et étoffé que celui-ci :) En attendant, testez vos propres idées.





À demain.

