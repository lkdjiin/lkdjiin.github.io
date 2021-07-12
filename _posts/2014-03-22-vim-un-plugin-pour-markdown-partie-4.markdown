---
layout: post
title: "Vim - un plugin pour markdown - partie 4"
date: 2014-03-22 20:42
legacy: true
tags: [vim, intermédiaire, markdown, plugin, bépo]
---



Maintenant on fait tous les titres, jusqu'au niveau 6 donc.

<!-- more -->

{% highlight vim %}
function s:build_big_title(char)
  let s:line_content = substitute(getline("."), '.', a:char, 'g')
  call append('.', s:line_content)
endfunction

function s:build_little_title(str)
  call setline(line('.'), a:str . getline('.'))
endfunction

function! quickmarkdown#title1()
  call s:build_big_title("=")
endfunction

function! quickmarkdown#title2()
  call s:build_big_title("-")
endfunction

function! quickmarkdown#title3()
  call s:build_little_title("### ")
endfunction

function! quickmarkdown#title4()
  call s:build_little_title("#### ")
endfunction

function! quickmarkdown#title5()
  call s:build_little_title("##### ")
endfunction

function! quickmarkdown#title6()
  call s:build_little_title("###### ")
endfunction
{% endhighlight %}

{% highlight vim %}
command! QuickMarkdownTitle1 call quickmarkdown#title1()
command! QuickMarkdownTitle2 call quickmarkdown#title2()
command! QuickMarkdownTitle3 call quickmarkdown#title3()
command! QuickMarkdownTitle4 call quickmarkdown#title4()
command! QuickMarkdownTitle5 call quickmarkdown#title5()
command! QuickMarkdownTitle6 call quickmarkdown#title6()
{% endhighlight %}

J'ai aussi changé mon mapping pour qu'il soit plus homogène.

**En qwerty:**

{% highlight vim %}
nmap <Leader>m1 :QuickMarkdownTitle1<Enter>
nmap <Leader>m2 :QuickMarkdownTitle2<Enter>
nmap <Leader>m3 :QuickMarkdownTitle3<Enter>
nmap <Leader>m4 :QuickMarkdownTitle4<Enter>
nmap <Leader>m5 :QuickMarkdownTitle5<Enter>
nmap <Leader>m6 :QuickMarkdownTitle6<Enter>
{% endhighlight %}

**En azerty:**

{% highlight vim %}
nmap <Leader>m& :QuickMarkdownTitle1<Enter>
nmap <Leader>mé :QuickMarkdownTitle2<Enter>
nmap <Leader>m" :QuickMarkdownTitle3<Enter>
nmap <Leader>m' :QuickMarkdownTitle4<Enter>
nmap <Leader>m( :QuickMarkdownTitle5<Enter>
nmap <Leader>m- :QuickMarkdownTitle6<Enter>
{% endhighlight %}

**En bépo:**

{% highlight vim %}
nmap <Leader>m" :QuickMarkdownTitle1<Enter>
nmap <Leader>m« :QuickMarkdownTitle2<Enter>
nmap <Leader>m» :QuickMarkdownTitle3<Enter>
nmap <Leader>m( :QuickMarkdownTitle4<Enter>
nmap <Leader>m) :QuickMarkdownTitle5<Enter>
nmap <Leader>m@ :QuickMarkdownTitle6<Enter>
{% endhighlight %}



À demain.



