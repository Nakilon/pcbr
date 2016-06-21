class PCBR

  VERSION = "0.0.1"

  def initialize &block
    @table = []
    @callback = block || ->_{[*_]}
  end

  def size
    @table.size
  end

  def store key, *vector
    vector = vector.empty? ? [key] : vector.first
    score = @table.map do |item|
      @callback[vector].zip(@callback[item[1]]).map do |a, b|
        a <=> b
      end.uniq.inject(0, :+).tap do |point|
        item[2] -= point
      end
    end.inject 0, :+
    @table.push [key, vector, score]
  end

  def score key
    @table.assoc(key).last
  end

  def sorted
    @table.sort_by.with_index{ |item, i| [item.last, i] }.map(&:first)
  end

  def data
    Hash[ @table.map{ |key, vector, score| [key, vector] } ]
  end
  def scores
    Hash[ @table.map{ |key, vector, score| [key, score] } ]
  end

end
