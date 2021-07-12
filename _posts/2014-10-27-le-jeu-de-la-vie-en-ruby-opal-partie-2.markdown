---
layout: post
title: "Le jeu de la vie en ruby (opal) - partie 2"
date: 2014-10-27 21:09
legacy: true
tags: [jeu de la vie, ruby, opal]
---



Deuxième partie du jeu de la vie en Ruby/Opal.rb, on va calculer le prochain
état d'une cellule, et extraire un *voisinage* de cellules d'une génération.
Après l'avoir écrit en Javascript, j'avoue que cette partie est quelque peu
ennuyeuse à reproduire. Je vais montrer du code, mais il y aura peu
d'explications, la logique étant la même qu'en Javascript (quoiqu'à base de
classes cette fois-ci).

<!-- more -->

Premier test et première classe pour spécifier une API.

{% highlight ruby %}
require './app/neighborhood.rb'

describe Neighborhood do

  let(:alive) { [1, 1, 1, 0, 0, 0, 0, 0, 0] }

  describe '#next_state' do

    it 'returns 1 when it will be alive' do
      neighborhood = Neighborhood.new(alive)
      expect(neighborhood.next_state).to eq 1
    end

  end

end
{% endhighlight %}

{% highlight ruby %}
class Neighborhood

  def initialize(cells)
    @cells = cells
  end

  def next_state
    1
  end
end
{% endhighlight %}

`next_state` doit être capable de determiner que la cellule va mourrir.

{% highlight ruby %}
require './app/neighborhood.rb'

describe Neighborhood do

  let(:alive)       { [1, 1, 1, 0, 0, 0, 0, 0, 0] }
  let(:dead)        { [0, 0, 1, 0, 0, 0, 0, 0, 0] }
  let(:dead2)       { [1, 1, 1, 1, 1, 1, 1, 1, 1] }
  let(:dead3)       { [0, 0, 0, 0, 0, 0, 0, 0, 0] }

  describe '#next_state' do

    ...

    it 'returns 0 when it will be dead' do
      [dead, dead2, dead3].each do |cells|
        neighborhood = Neighborhood.new(cells)
        expect(neighborhood.next_state).to eq 0
      end
    end
{% endhighlight %}

{% highlight ruby %}
class Neighborhood

  ALIVE = 3

  def initialize(cells)
    @sum = cells.reduce(:+)
  end

  def next_state
    @sum == ALIVE ? 1 : 0
  end
end
{% endhighlight %}

Quand le nombre de cellules vivantes du voisinage est 4, le prochain état de
la cellule est le même que l'état actuel.

{% highlight ruby %}
require './app/neighborhood.rb'

describe Neighborhood do

  ...

  let(:status_quo1) { [1, 1, 1, 1, 0, 0, 0, 0, 0] }
  let(:status_quo2) { [0, 1, 1, 1, 1, 0, 0, 0, 0] }

  describe '#next_state' do

    ...

    it 'returns old state in other cases' do
      neighborhood = Neighborhood.new(status_quo1)
      expect(neighborhood.next_state).to eq 0

      neighborhood = Neighborhood.new(status_quo2)
      expect(neighborhood.next_state).to eq 1
    end
  end

end
{% endhighlight %}

{% highlight ruby %}
class Neighborhood

  ALIVE = 3
  STATUS_QUO = 4

  def initialize(cells)
    @subject = cells[4]
    @sum = cells.reduce(:+)
  end

  def next_state
    case @sum
    when ALIVE then 1
    when STATUS_QUO then @subject
    else
      0
    end
  end
end
{% endhighlight %}

Extraire un voisinage de cellules
---------------------------------

Il faut pouvoir extraire un ensemble de 9 cellules (le *voisinage*) d'une
génération.

{% highlight ruby %}
require './app/neighborhood_extractor.rb'

describe NeighborhoodExtractor do

  let(:generation) do
    [
      [0, 1, 0, 1],
      [1, 0, 1, 0],
      [0, 1, 1, 0]
    ]
  end

  it 'returns 9 cells' do
    x, y = 1, 1
    extractor = NeighborhoodExtractor.new(generation, x, y)
    expect(extractor.cells.size).to eq 9
  end

end
{% endhighlight %}

Ça, c'est juste la mise en train.

{% highlight ruby %}
class NeighborhoodExtractor

  def initialize(generation, x, y)
  end

  def cells
    Array.new(9)
  end
end
{% endhighlight %}

Là, on commence à faire quelque chose d'utile.

{% highlight ruby %}
describe NeighborhoodExtractor do

  let(:generation) do
    [
      [0, 1, 0, 1],
      [1, 0, 1, 0],
      [0, 1, 1, 0]
    ]
  end

  ...

  describe 'inner position' do
    specify 'x=1 y=1' do
      extractor = NeighborhoodExtractor.new(generation, 1, 1)
      expect(extractor.cells).to eq [0, 1, 0, 1, 0, 1, 0, 1, 1]
    end
  end
end
{% endhighlight %}

{% highlight ruby %}
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [
      *generation[y-1][x-1..x+1],
      *generation[y][x-1..x+1],
      *generation[y+1][x-1..x+1],
    ]
  end
end
{% endhighlight %}

Maintenant, voyons le problème des bordures.

{% highlight ruby %}
  describe 'borders' do
    specify 'x=1 y=0' do
      extractor = NeighborhoodExtractor.new(generation, 1, 0)
      expect(extractor.cells).to eq [0, 0, 0, 0, 1, 0, 1, 0, 1]
    end
  end
{% endhighlight %}

La manière dont le test échoue est intéressante. C'est du à la façon dont Ruby
gère les indexs négatifs pour les tableaux, ceux-cis sont parfaitement
autorisés.

    Failures:

      1) NeighborhoodExtractor borders x=1 y=0
         Failure/Error: expect(extractor.cells).to eq [0, 0, 0, 0, 1, 0, 1, 0, 1]
           
           expected: [0, 0, 0, 0, 1, 0, 1, 0, 1]
                got: [0, 1, 1, 0, 1, 0, 1, 0, 1]
           
           (compared using ==)
         # ./spec/neighborhood_extractor_spec.rb:29:in `block (3 levels) in <top (required)>'

{% highlight ruby %}
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [
      *row1,
      *generation[y][x-1..x+1],
      *generation[y+1][x-1..x+1],
    ]
  end

  def row1
    if y == 0
      [0, 0, 0]
    else
      generation[y-1][x-1..x+1]
    end
  end
end
{% endhighlight %}

Testons avec la bordure du bas.

{% highlight ruby %}
    specify 'x=2 y=2' do
      extractor = NeighborhoodExtractor.new(generation, 2, 2)
      expect(extractor.cells).to eq [0, 1, 0, 1, 1, 0, 0, 0, 0]
    end
{% endhighlight %}

{% highlight ruby %}
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  ...

  def row3
    if y == generation.size - 1
      [0, 0, 0]
    else
      generation[y+1][x-1..x+1]
    end
  end
end
{% endhighlight %}

Un peu de refactoring.

{% highlight ruby %}
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [ *group_of_tree(y - 1), *group_of_tree(y), *group_of_tree(y + 1) ]
  end

  def group_of_tree(row)
    if row < 0 || row == generation.size
      [0, 0, 0]
    else
      generation[row][x-1..x+1]
    end
  end

end
{% endhighlight %}

La bordure de gauche.

{% highlight ruby %}
    specify 'x=0 y=1' do
      extractor = NeighborhoodExtractor.new(generation, 0, 1)
      expect(extractor.cells).to eq [0, 0, 1, 0, 1, 0, 0, 0, 1]
    end
{% endhighlight %}

{% highlight ruby %}
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [ *group_of_tree(y - 1), *group_of_tree(y), *group_of_tree(y + 1) ]
  end

  def group_of_tree(row)
    if row < 0 || row == generation.size
      [0, 0, 0]
    else
      if x == 0
        [ 0, *generation[row][x..x+1] ]
      else
        generation[row][x-1..x+1]
      end
    end
  end

end
{% endhighlight %}

Et enfin celle de droite.

{% highlight ruby %}
    specify 'x=3 y=1' do
      extractor = NeighborhoodExtractor.new(generation, 3, 1)
      expect(extractor.cells).to eq [0, 1, 0, 1, 0, 0, 1, 0, 0]
    end
{% endhighlight %}

Ok, c'est moche, mais ça fonctionne.

{% highlight ruby %}
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [ *group_of_tree(y - 1), *group_of_tree(y), *group_of_tree(y + 1) ]
  end

  def group_of_tree(row_index)
    if row_index < 0 || row_index == generation.size
      [0, 0, 0]
    else
      if x == 0
        [ 0, *generation[row_index][x..x+1] ]
      elsif x == generation.first.size - 1
        [*generation[row_index][x-1..x], 0]
      else
        generation[row_index][x-1..x+1]
      end
    end
  end

end
{% endhighlight %}

Je devrais *refactorer* ce code, mais comme je sais qu'il va bientôt changer
(quand on va supprimer les bordures de la surface de jeu) je me dis qu'on verra
bien à ce moment là.

À noter pour finir que je ne teste pas les cas des cellules de coin. Nous avons
vu dans la version Javascript que si les cellules des bords droits, gauches,
hauts et bas fonctionnent, alors les coins fonctionnent aussi.

La prochaine fois on verra la classe `Game` et une petite astuce pour faire
un `sleep` like en Opal.rb.




