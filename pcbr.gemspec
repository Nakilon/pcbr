Gem::Specification.new do |spec|
  spec.name          = "pcbr"
  spec.version       = "0.4.0"
  spec.summary       = "Pair Comparison Based Rating"

  spec.author        = "Victor Maslov"
  spec.email         = "nakilon@gmail.com"
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/Nakilon/pcbr"
  spec.description   = <<-EOF
    Making ratings is fun. After applying my method several times I've decided to gemify it.
    This is one of the first gems I made so it's far for being nicely done.
  EOF

  spec.test_files    = ["spec/"]
  spec.files         = `git ls-files -z`.split(?\0) - spec.test_files

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec", "~> 3.3.0"

  spec.required_ruby_version = ">= 2.0.0"
end
