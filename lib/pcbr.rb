module PCBR
  VERSION = "0.3.0"


  def self.new &block
    Storage.new &block
  end

  ARRAY_101 = [0, 0, 0]
  class Storage
  attr_reader :table

  def initialize &block
    @table = []
    @callback = block || lambda{ |a_, b_|
      ARRAY_101.dup.tap do |array|
        [*a_].zip([*b_]) do |a, b|
          t = a <=> b and array[t] = t
        end
      end.inject :+
    }
  end

  def store key, vector = nil
    vector ||= Array key
    score = 0
    @table.each do |item|
      # TODO test of this exception
      fail "comparison vectors are of the different length" unless vector.size == item[1].size
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

  # def quality
  #   factorial = ->x{ (1..x).inject(:*) }
  #   (2...@table.size).each do |sublength|
  #     combinations = factorial[@table.size] / factorial[sublength] / factorial[@table.size - sublength]
  #     comparisons = sublength * (sublength - 1) / 2
  #     p [sublength, combinations, comparisons, combinations * comparisons]
  #   end
  # end

end
end
