---
layout: post
title: "Support de la syntaxe Kick Assembler dans la gem Rouge"
date: 2026-04-01 8:00
comments: true
tags: [ ruby, 6502 ]
---

Ça n'était pas drôle d'écrire des articles sur l'assembleur 6502 et de voir que
les bouts de code était moches et ne pouvait pas être bien
mise en évidence (_highlight_).

<!-- more -->

En effet la gem **Rouge**, qui est utilisée par **Jekyll** pour le _syntax highlighting_
ne prend pas en compte la syntaxe (parfois particulière) de l'assembleur
**Kick Assembler**.

J'ai donc écrit un lexer pour cette gem :

Avant
{% highlight nasm %}
.const COLOR = $a286
start:
  jsr init_screen
  lda $d01a // INTERRUPT_CONTROL
  ora #%00000001
  sta $d01a

init_screen: {
  ldx #0
  stx $d020 // border
  stx $d021 // background
  rts
}
{% endhighlight %}

Après
{% highlight kickass %}
.const COLOR = $a286
start:
  jsr init_screen
  lda $d01a // INTERRUPT_CONTROL
  ora #%00000001
  sta $d01a

init_screen: {
  ldx #0
  stx $d020 // border
  stx $d021 // background
  rts
}
{% endhighlight %}

Pour l'instant j'utilise ma branche directement dans le Gemfile de Jekyll :

{% highlight ruby %}
gem "rouge", git: 'git@github.com:lkdjiin/rouge.git', branch: 'kickass'
{% endhighlight %}

Il semblerait que [ma PR](https://github.com/rouge-ruby/rouge/pull/2262) soit
sur le point d'être acceptée. Sinon j'en ferais sûrement un plugin.
