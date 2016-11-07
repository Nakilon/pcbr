class PCBR

  VERSION = "0.1.3"

  attr_reader :table

  def initialize &block
    @table = []
    @callback = block || ->*_{[*_[0]]}
  end

  # def size
  #   @table.size
  # end

  ARRAY_101 = [0, 0, 0]
  def store key, *vector
    vector = vector.empty? ? [key] : vector.first
    calculated = @callback[vector, key]
    score = 0
    @table.each do |item|
      array = ARRAY_101.dup
      calculated.zip(item[3]).each do |a, b|
        next unless t = a <=> b
        array[t] = t
      end
      point = array.inject :+
      score += point
      item[2] -= point
    end
    @table.push [key, vector, score, calculated]
  end

  def score key
    @table.assoc(key)[-2]
  end

  def sorted
    # from the best to the worst
    @table.sort_by.with_index{ |item, i| [-item[2], i] }.map(&:first)
  end

end
