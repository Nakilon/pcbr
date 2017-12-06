Gem::Specification.new do |spec|
  spec.name          = "pcbr"
  spec.version       = (require_relative "lib/pcbr"; PCBR::VERSION)
  spec.author        = "Victor Maslov"
  spec.email         = "nakilon@gmail.com"
  spec.summary       = "Pair Comparison Based Rating"
  spec.description   = "Making ratings is fun. After applying my method several times I've decided to gemify it."
  spec.homepage      = "https://github.com/Nakilon/pcbr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = ["spec/"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec", "~> 3.3.0"

  spec.required_ruby_version = ">= 2.0.0"
end
