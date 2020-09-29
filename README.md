# PCBR (Pairs Comparison Based Rating)

You often need to sort an array of vectors. This allows you to do it without knowing the optimal ranking function and with some pairs of vectors that are not even comparable.

### Examples

See [`describe "examples" do` in specs](spec/_spec.rb).

### How it works

The first idea was in 2013 -- at that time I was imagining it as a tree data structure. Later in May 2015 I've realised that it's really about dots in n-dimensional space and sectors, and round-robin. Applying it to Reddit RSS feed made it 50% more interesting. It also applied well to boost tree search process in the [bad Facebook advertisment classifier](https://drive.google.com/file/d/0B3BLwu7Vb2U-SVhKYWVMR2JvOFk/view?usp=sharing) production project. Since then I mostly use it to oprimize tree searches, it's basically an automated replacement for euristics.

### Installation

    $ gem install pcbr

### Testing

    rspec

or

    rake spec

### TODO

Illustrate this README, replace rspec with minitest.
