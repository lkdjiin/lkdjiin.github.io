---
layout: post
title: "Vim - Un plugin pour markdown - partie 5"
date: 2014-03-23 20:57
legacy: true
tags: [vim, intermédiaire, markdown, plugin, bépo]
---



On fait un peu de nettoyage en mettant du code en commun, et on voit un
mapping plus intéressant.

<!-- more -->

Voici ce que ça donne après un refactoring:

{% highlight vim %}
function s:build_big_title(char)
  let s:line_content = substitute(getline("."), '.', a:char, 'g')
  call append('.', s:line_content)
endfunction

function s:build_little_title(str)
  call setline(line('.'), a:str . getline('.'))
endfunction

function! quickmarkdown#title(level)
  if a:level == 1
    call s:build_big_title("=")
  elseif a:level == 2
    call s:build_big_title("-")
  elseif a:level == 3
    call s:build_little_title("### ")
  elseif a:level == 4
    call s:build_little_title("#### ")
  elseif a:level == 5
    call s:build_little_title("##### ")
  elseif a:level == 6
    call s:build_little_title("###### ")
  endif
endfunction
{% endhighlight %}

{% highlight vim %}
command! QuickMarkdownTitle1 call quickmarkdown#title(1)
command! QuickMarkdownTitle2 call quickmarkdown#title(2)
command! QuickMarkdownTitle3 call quickmarkdown#title(3)
command! QuickMarkdownTitle4 call quickmarkdown#title(4)
command! QuickMarkdownTitle5 call quickmarkdown#title(5)
command! QuickMarkdownTitle6 call quickmarkdown#title(6)
{% endhighlight %}

On n'a plus qu'un seule fonction `quickmarkdown#title`, à laquelle on passe
en paramêtre le niveau du titre.

J'ai aussi changé le mapping.
Tout d'abord j'utilise leader+q, au lieu de leader+m. Pourquoi, parce que
je voulais m'en servir aussi en mode insertion avec la touche Control. Et
en mode insertion, Control+m est équivalent à la touche Entrée, ce qui pose
bien sûr quelques problèmes ;) Voici le mapping pour un clavier qwerty:

{% highlight vim %}
nmap <Leader>q1 :QuickMarkdownTitle1<Enter>
nmap <Leader>q2 :QuickMarkdownTitle2<Enter>
nmap <Leader>q3 :QuickMarkdownTitle3<Enter>
nmap <Leader>q4 :QuickMarkdownTitle4<Enter>
nmap <Leader>q5 :QuickMarkdownTitle5<Enter>
nmap <Leader>q6 :QuickMarkdownTitle6<Enter>
imap <C-q>1 <C-o>:QuickMarkdownTitle1<Enter>
imap <C-q>2 <C-o>:QuickMarkdownTitle2<Enter>
imap <C-q>3 <C-o>:QuickMarkdownTitle3<Enter>
imap <C-q>4 <C-o>:QuickMarkdownTitle4<Enter>
imap <C-q>5 <C-o>:QuickMarkdownTitle5<Enter>
imap <C-q>6 <C-o>:QuickMarkdownTitle6<Enter>
{% endhighlight %}

Au fait, vous pouvez trouver ce plugin sur [Github](https://github.com/lkdjiin/quickmarkdown).



À demain.



