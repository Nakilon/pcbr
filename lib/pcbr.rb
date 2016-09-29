class PCBR

  VERSION = "0.1.1"

  attr_reader :table

  def initialize &block
    @table = []
    @callback = block || ->*_{[*_[0]]}
  end

  # def size
  #   @table.size
  # end

  def store key, *vector
    vector = vector.empty? ? [key] : vector.first
    calculated = @callback[vector, key]
    score = @table.map do |item|
      calculated.zip(item[3]).map do |a, b|
        a <=> b
      end.uniq.inject(0, :+).tap do |point|
        item[2] -= point
      end
    end.inject 0, :+
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
