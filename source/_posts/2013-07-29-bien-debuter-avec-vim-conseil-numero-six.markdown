---
layout: post
title: "Bien débuter avec Vim: conseil numéro six"
date: 2013-07-29 08:05
comments: true
categories: [vim, conseil, débutant]
---

{% level 1 %}

Ne mettez pas n'importe quoi dans votre .vimrc
----------------------------------------------
Le fichier `.vimrc` est LE fichier de configuration de Vim. C'est dans ce fichier
que vous personnaliserez votre Vim. C'est donc un fichier très important et on
peut être tenté d'utiliser celui de quelqu'un d'autre. Ne le faites surtout pas
!

<!-- more -->

Vim est un éditeur hautement configurable, paramétrable et personnalisable.
Je peux utiliser le Netbeans ou le Notepad++ de mon collègue mais
j'aurai du mal à utiliser son Vim, tellement il est différent du mien. C'est ce
qui fait la force de Vim, il fini par vous ressembler… À la fin du tutoriel
intégré, vous aurez un fichier `.vimrc` très suffisant pour commencer. Et vous
devriez suivre une règle simple :

{% blockquote %}
Ajoutez une ligne à votre .vimrc uniquement si vous comprenez cette ligne.
{% endblockquote %}

Il y a bien sûr des exceptions. Par exemple, si votre clavier est loin
de la disposition *azerty* ou *qwerty* (comme moi qui suis en *bépo*) vous
serez bien
obligé de remapper un certain nombre de touches dès le début. Je vous conseille
aussi fortement de désactiver les touches fléchées. En effet leur usage est
tellement ancré dans nos têtes que vous les utiliserez sans vous en rendre
compte, ce qui ne pourrait que vous ralentir dans votre progression.
Pour cela, ajoutez les lignes suivantes dans votre `.vimrc` :

``` vim
" Les touches fléchées sont désactivées.
" Utile pour apprendre vim.
"
" En mode normal, vous pourrez les utiliser plus tard
" pour faire quelque chose d'utile.
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
" En mode insertion, vous pourrez enlever la
" désactivation dans quelques semaines.
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
```

N'hésitez pas à consulter l'aide de vim pour bien comprendre ce que font ces
lignes de code *avant* de les ajouter dans votre `.vimrc` ;)



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.
{% connexe %}
