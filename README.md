# PCBR (Pairs Comparison Based Rating)

Making ratings is fun. After applying my method several times I've decided to gemify it.

### Examples

See [`describe "examples" do` in specs](spec/_spec.rb).

### How it works

The first idea of rating items by one-to-one comparison was about QuakeLive players in 2013 or so and it didn't work well. At that time I was thinking about tree data structure. Later in May 2015 I've realised that it's really about dots in n-dimensional space and sectors. Applying it to Reddit RSS made my feed 50% more interesting.

TODO: describe/illustrate algorithm?

~~At the moment it's a "proof of concept" -- it needs huge optimisations for lookups, maybe using trees.~~

It worked fine in production for a project with huge computations where you can't find the best solution but have to find anything good in adequate time. Traversing the tree using this with a vector of `[leaf's quality, depth]` made things better than depth-first search with lots of ueristics.

### Installation

    $ gem install pcbr

### Testing with RSpec before contributing

    rspec

or

    rake spec
