require_relative "../lib/pcbr"

describe PCBR do

  example "#size" do
    rating = PCBR.new
    rating.store 1
    rating.store 2
    expect(rating.size).to eq(2)
  end

  example "order, #score[key] and main methods" do
    rating = PCBR.new
    data = {
      1 => [1, 1],
      2 => [2, 2],
      3 => [0, 0],
      4 => [1, 2],
      6 => [1, 1],
      5 => [0, 2],
    }.each do |key, vector|
      rating.store key, vector
    end
    expectation = {
      2 =>  5,
      4 =>  3,
      1 => -1,
      6 => -1,
      5 => -1,
      3 => -5,
    }.each do |item, score|
      expect(rating.score(item)).to eq(score)
    end
    expect(rating.sorted).to eq(expectation.keys)
    expect(rating.scores).to eq(expectation     )
    expect(rating.data  ).to eq(data            )
  end

  example "&block" do
    rating = PCBR.new do |item|
      [item[:goodness], -item[:badness]]
    end
    rating.store 2, {goodness: 1, badness: 2}
    rating.store 1, {goodness: 1, badness: 1}
    expect(rating.sorted).to eq([1, 2])
  end

  example "scalar key without vector and without &block" do
    rating = PCBR.new
    rating.store 1
    rating.store 2
    expect(rating.sorted).to eq([2, 1])
  end

end
