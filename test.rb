require "minitest/autorun"

require_relative "lib/pcbr"

describe "basic specs" do

  it "scalar key without vector and without &block" do
    rating = PCBR.new
    rating.store 1
    rating.store 2
    assert_equal [2, 1], rating.sorted
  end

  it "raises if vectors are of the different length" do
    rating = PCBR.new
    rating.store 1, [2]
    assert_raises(PCBR::Error){ rating.store 3, [4, 5] }
  end

  # it "#size" do
  #   rating = PCBR.new
  #   rating.store 1
  #   rating.store 2
  #   assert_equal 2, rating.size
  # end

  it "Nil elements in vector are ignored" do
    rating = PCBR.new
    rating.store 1, [1, nil]
    rating.store 2, [2, nil]
    rating.store 3, [nil, 3]
    rating.store 4, [nil, 4]
    assert_equal [2, 4, 1, 3], rating.sorted
  end

  it "&block" do
    n = 0
    rating = PCBR.new do |a, b|
      n += 1
      a <=> b
    end
    rating.store 1
    rating.store 2
    rating.store 3
    rating.store 4
    assert_equal [4, 3, 2, 1], rating.sorted
    assert_equal 6, n
  end

  it "the vector is not neccessary an Array" do
    rating = PCBR.new do |a, b|
      a <=> b
    end
    0.class.class_eval do
      def size
        fail
      end
    end
    rating.store 1, 2
    rating.store 2, 1
    assert_equal [1, 2], rating.sorted
  end

  it "#sorted and #score[key]" do
    rating = PCBR.new
    table = [
      [1, [1, 1], -1],
      [2, [2, 2],  5],
      [3, [0, 0], -5],
      [4, [1, 2],  3],
      [6, [1, 1], -1],
      [5, [0, 2], -1],
    ].each do |key, vector, |
      rating.store key, vector
    end
    assert_equal [2, 4, 1, 6, 5, 3], rating.sorted
    assert_equal 0, rating.table.map{ |i| i[2] }.inject(:+)
    table.each do |key, _, score|
      assert_equal score, rating.score(key)
    end
    assert_equal table, rating.table
  end

  # it "quality estimation" do
  #   rating = PCBR.new
  #   table = [
  #     [1, [1, 1]],
  #     [2, [2, 2]],
  #     [3, [0, 0]],
  #     [4, [1, 2]],
  #     [6, [1, 1]],
  #     [5, [0, 2]],
  #   ].each do |key, vector, |
  #     rating.store key, vector
  #   end
  # end

  it "duplicating keys are forbidden" do
    rating = PCBR.new
    rating.store 0
    assert_raises(PCBR::Error){ rating.store 0 }
  end

end


describe "examples" do

  it "github repos" do
    repos = {
      # Image Processing Library
      "IPL: ImageMagick/ImageMagick" => {issue: 36, pr: 0, watch: 29, star: 375, fork: 89},
      "IPL: jcupitt/libvips" => {issue: 32, pr: 1, watch: 43, star: 753, fork: 72},
      # Packet Manager
      "PM: Homebrew/brew" => {issue: 14, pr: 13, watch: 61, star: 1207, fork: 345},
      "PM: Linuxbrew/brew" => {issue: 21, pr: 2, watch: 5, star: 52, fork: 345},
      # one gem depending on another one
      "gem: dblock/slack-ruby-bot" => {issue: 15, pr: 0, watch: 13, star: 251, fork: 55},
      "gem: dblock/slack-ruby-client" => {issue: 22, pr: 2, watch: 4, star: 206, fork: 37},
      # Programming Language
      "PL: crystal-lang/crystal" => {issue: 267, pr: 44, watch: 255, star: 4952, fork: 412},
      "PL: elixir-lang/elixir" => {issue: 21, pr: 1, watch: 518, star: 7029, fork: 975},
      "PL: golang/go" => {issue: 2293, pr: 1, watch: 1521, star: 17067, fork: 2147},
      "PL: racket/racket" => {issue: 33, pr: 53, watch: 124, star: 1455, fork: 301},
      "PL: rust-lang/rust" => {issue: 2411, pr: 119, watch: 1012, star: 16790, fork: 3200},
      # Ruby Web Framework
      "RWF: padrino/padrino-framework" => {issue: 44, pr: 2, watch: 137, star: 2782, fork: 454},
      "RWF: sinatra/sinatra" => {issue: 12, pr: 11, watch: 377, star: 7892, fork: 1467},
      # Ruby Version Manager
      "RVM: rbenv/rbenv" => {issue: 24, pr: 12, watch: 301, star: 8257, fork: 769},
      "RVM: rvm/rvm" => {issue: 160, pr: 5, watch: 154, star: 3328, fork: 793},
      # DevOps Tool
      "DOT: ansible/ansible" => {issue: 1074, pr: 322, watch: 1339, star: 16926, fork: 5075},
      "DOT: chef/chef" => {issue: 422, pr: 52, watch: 387, star: 4265, fork: 1774},
      "DOT: capistrano/capistrano" => {issue: 38, pr: 6, watch: 339, star: 8392, fork: 1365},
    }

    create_rating = lambda do |&callback|
      PCBR.new.tap do |rating|
        repos.each do |repo_name, repo_stats|
          rating.store repo_name, callback[repo_stats, repo_name]
        end
      end
    end

    contribution_intensivity_rating = create_rating.call do |repo_stats| [
      repo_stats[:pr],
      -repo_stats[:fork],
    ] end

    quality_rating = create_rating.call do |repo_stats| [
      repo_stats[:star],
      -repo_stats[:issue],
    ] end

    resulting_rating = create_rating.call do |repo_stats, repo_name| [
      contribution_intensivity_rating.score(repo_name),
      quality_rating.score(repo_name),
    ] end

    assert_equal [
        ["PM:", %w{ Homebrew/brew Linuxbrew/brew }],
        ["RVM:", %w{ rbenv/rbenv rvm/rvm }],
        ["PL:", %w{ racket/racket crystal-lang/crystal elixir-lang/elixir rust-lang/rust golang/go }],
        ["DOT:", %w{ ansible/ansible capistrano/capistrano chef/chef }],
        ["RWF:", %w{ sinatra/sinatra padrino/padrino-framework }],
        ["gem:", %w{ dblock/slack-ruby-bot dblock/slack-ruby-client }],
        ["IPL:", %w{ jcupitt/libvips ImageMagick/ImageMagick }],
    ], resulting_rating.sorted.map(&:split).group_by(&:first).each{ |category, group| group.map! &:last }.to_a
  end

end
