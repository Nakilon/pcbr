module PCBR
  class Error < RuntimeError
    # def initialize body
    #   super "#{Module.nesting[1]} error: #{body}"
    # end
  end

  def self.new &block
    Storage.new &block
  end

  ARRAY_101 = [0, 0, 0]
  class Storage
    attr_reader :table

    def initialize &block
      @table = []
      @callback = block || lambda{ |a_, b_|
        raise Error.new "comparison vectors are of the different length" unless a_.size == b_.size
        ARRAY_101.dup.tap do |array|
          [*a_].zip([*b_]) do |a, b|
            t = a <=> b and array[t] = t
          end
        end.inject :+
      }
    end

    def store key, vector = nil
      raise Error.new "duplicating key" if @table.assoc key
      key = [NilClass, FalseClass, TrueClass, Numeric, Symbol, Method].any?{ |c| key.is_a? c } ? key : key.dup
      vector = if vector.nil?
        Array key
      else
        vector
      end
      score = 0
      @table.each do |item|
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
