---
layout: post
title: "Les arbres browniens"
date: 2016-01-17 23:30
comments: true
categories: [ruby, jruby, brownian tree, arbre, mouvement brownien]
---

Ce week end j'ai joué avec les arbres browniens (*brownian trees*).
Ce sont des agglomerats de cellules qui ressemblent vaguement à des arbres,
obtenus à partir d'un mouvement brownien. Et le mouvement brownien, c'est cool.

C'est Robert Brown, un
botaniste, qui le décrit en 1827 en observant des petites particles qui
semblaient bouger toutes seules. Il voit ses particules avoir la tremblote, mais
sans pouvoir expliquer pourquoi.

C'est d'autant plus cool qu'en 1905, en donnant l'explication du mouvement
brownien, Albert Enstein va fournir la preuve de l'existence des atomes.

Le mouvement brownien c'est simplement les atomes qui *cognent* dans tout les
sens sur des particules.

{% img center /images/brownian-tree.png %}

<!-- more -->

L'algorithme pour créer un arbre brownien est enfantin:

1. Positionner au hasard une première cellule gelée qui sert de *graine*.
2. Positionner au hasard une cellule libre.
3. Mouvoir au hasard la cellule libre, c'est le mouvement brownien.
4. Quand la cellule libre *rencontre* une cellule gelée, elle gèle elle-même
   et on recommence au point 2.

Mettre les cellules libres une par une, c.à.d attendre qu'une rencontre avec une
cellule gelée se produise avant de passer à la cellule libre suivante est trop
long. Avec un dispositif d'affichage assez grand on pourrait y passer plusieurs
jours.
Donc je met toutes les cellules libres dès le départ, ainsi il se passe très
vite beaucoup de choses.

J'ai fait [une vidéo de la construction d'un arbre brownien](https://www.youtube.com/watch?v=wQnTUZHfSKA&feature=youtu.be) pour que vous puissiez visualiser comment ça fonctionne.

<iframe width="420" height="315" src="https://www.youtube.com/embed/wQnTUZHfSKA" frameborder="0" allowfullscreen></iframe>

J'ai écrit un programme en JRuby pour faire un arbre brownien basique.  Le code
n'est pas beau car il n'a pas été pensé pour durer plus que le temps d'un
week-end. Malgré tout, je pense qu'il est compréhensible et qu'il peut servir
de base pour des idées plus sophistiquées.

```ruby
include Java

# It's Ruby… but it's also Java… so… import…
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.Timer
import java.awt.Color
import java.awt.Dimension
import java.awt.Toolkit
import java.awt.event.ActionListener

SIZE = 200        # Both width and height of the *image*.
SCALE = 2         # Multiply size by scale to obtain the *window* size.
FREE_TOTAL = 6000 # Number of particles to agregate.
DELAY = 20        # Time to wait between *screen refreshes*.

VOID = 0   # A cell with nothing in itself.
FROZEN = 1 # A cell already agregated.

class BrownianTree < JFrame
  include ActionListener

  def initialize
    super("Brownian Tree")
    init_ui
  end

  def init_ui
    @board = Board.new
    @board.setPreferredSize(Dimension.new(SIZE * SCALE, SIZE * SCALE))
    add(@board)
    pack
    setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    setVisible(true)

    @timer = Timer.new(DELAY, self)
    @timer.start
  end

  # Called every DELAY millisecond, thanks to the *magic* of
  # ActionListener.
  def actionPerformed(e)
    @board.move
    @board.repaint
  end

end

class Board < JPanel

  def initialize
    super
    init_board
  end

  def init_board
    setBackground(Color.black)

    # An array of SIZE x SIZE.
    @cells = Array.new(SIZE) { Array.new(SIZE, VOID) }

    # The cell in the middle is the seed.
    @cells[SIZE / 2][SIZE / 2] = FROZEN

    # All free cells from the start, at random (x y) positions.
    @free_cells = Array.new(FREE_TOTAL) do
      [rand(SIZE), rand(SIZE)]
    end
  end

  # Called by `repaint` in BrownianTree. Yep, that's right, `repaint`
  # call `paint`. It's also Java, after all…
  def paint(g)
    super(g)
    update_board(g)
    Toolkit.getDefaultToolkit.sync
    g.dispose
  end

  # Display frozen cells in white and free cells in red.
  def update_board(g)
    g.setColor(Color::WHITE)
    SIZE.times do |i|
      SIZE.times do |j|
        if @cells[i][j] == FROZEN
          g.fillRect(i * SCALE, j * SCALE, SCALE, SCALE)
        end
      end
    end

    g.setColor(Color::RED)
    @free_cells.each do |cell|
      g.fillRect(cell[0] * SCALE, cell[1] * SCALE, SCALE, SCALE)
    end
  end

  def move
    # Move each free cell, one cell up or up-right or right or etc...
    @free_cells.map! do |cell|
      c = [
        cell[0] + [-1, 0, 1].shuffle.first,
        cell[1] + [-1, 0, 1].shuffle.first
      ]

      if c[0] < 0 || c[0] >= SIZE || c[1] < 0 || c[1] >= SIZE
        [rand(SIZE), rand(SIZE)]
      else
        c
      end
    end

    # Freeze each free cell that have at least 1 neighbor.
    @free_cells.map! do |cell|
      if has_neighbors?(cell)
        @cells[cell[0]][cell[1]] = FROZEN
        nil
      else
        cell
      end
    end

    @free_cells.compact!
  end

  def has_neighbors?(cell)
    if cell[0] < 1 || cell[0] > SIZE - 2 || cell[1] < 1 || cell[1] > SIZE - 2
      return false
    end
    if @cells[cell.first - 1][cell.last - 1] == FROZEN ||
       @cells[cell.first][cell.last - 1] == FROZEN ||
       @cells[cell.first + 1][cell.last - 1] == FROZEN ||
       @cells[cell.first + 1][cell.last] == FROZEN ||
       @cells[cell.first + 1][cell.last + 1] == FROZEN ||
       @cells[cell.first][cell.last + 1] == FROZEN ||
       @cells[cell.first - 1][cell.last + 1] == FROZEN ||
       @cells[cell.first][cell.last + 1] == FROZEN
      true
    else
      false
    end
  end

end

BrownianTree.new
```

On se retrouve bientôt pour que je vous parle des quelques variations que j'ai
essayé autour du thème des arbres browniens.

{% connexe %}
