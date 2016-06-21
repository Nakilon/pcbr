Gem::Specification.new do |spec|
  spec.name          = "pcbr"
  spec.version       = (require_relative "lib/pcbr"; PCBR::VERSION)
  spec.author        = "Victor Maslov"
  spec.email         = "nakilon@gmail.com"
  spec.summary       = "Pair Comparision Based Rating"
  spec.description   = "not public yet"
  spec.homepage      = "https://github.com/Nakilon/pcbr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = ["spec/"]

  spec.add_development_dependency "bundler", "~> 1.12.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"

  spec.required_ruby_version = ">= 2.0.0"
end
