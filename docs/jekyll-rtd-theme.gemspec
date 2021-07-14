Gem::Specification.new do |spec|
  spec.name          = "jekyll-rtd-theme"
  spec.version       = "0.0.1"
  spec.authors       = ["zearp"]
  spec.email         = ["zearp@localhost"]

  spec.summary       = "OptiHack"
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/zearp/OptiHack"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "github-pages", "~> 209"
end
