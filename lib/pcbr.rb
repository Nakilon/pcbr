module PCBR
  class Error < RuntimeError
    # def initialize body
    #   super "#{Module.nesting[1]} error: #{body}"
    # end
  end

  def self.new &block
    Storage.new &block
  end

  class Storage
    attr_reader :table
    attr_reader :set
    @@default_lambda = lambda do |a_, b_|
      raise Error.new "comparison vectors are of the different length" unless a_.size == b_.size
      tt = [0, 0, 0]
      [*a_].zip([*b_]) do |a, b|
        t = a <=> b and tt[t] = t
      end
      tt[0] + tt[1] + tt[2]
    end

    def initialize &block
      require "set"
      @set = ::Set.new
      @table = []
      @callback = block || @@default_lambda
    end

    def store key, vector = nil
      raise Error.new "duplicating key" if @set.include? key
      key = key.class.methods.include?(:new) ? key.dup : key  # https://stackoverflow.com/a/20957908/322020
      vector = Array key if vector.nil?
      score = 0
      @table.each do |item|
        point = @callback.call vector, item[1]
        item[2] -= point
        score += point
      end
      @set.add key
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
end
