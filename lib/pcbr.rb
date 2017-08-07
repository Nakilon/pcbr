class PCBR

  VERSION = "0.2.0"

  attr_reader :table

  ARRAY_101 = [0, 0, 0]
  def initialize &block
    @table = []
    @callback = block || ( lambda do |a_, b_|
      array = ARRAY_101.dup
      [*a_].zip([*b_]) do |a, b|
        next unless t = a <=> b
        array[t] = t
      end
      array.inject :+
    end )
  end

  # def size
  #   @table.size
  # end

  def store key, *vector
    vector = vector.empty? ? key : vector.first
    score = 0
    @table.each do |item|
      fail unless [*vector].size == [*item[1]].size

      point = @callback.call vector, item[1]

      score += point
      item[2] -= point
    end
    @table.push [key, vector, score]
  end

  def score key
    @table.assoc(key)[2]
  end

  def sorted
    # from the best to the worst
    @table.sort_by.with_index{ |item, i| [-item[2], i] }.map(&:first)
  end

end
