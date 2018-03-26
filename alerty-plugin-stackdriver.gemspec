# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "alerty-plugin-stackdriver"
  spec.version       = "0.1.0"
  spec.authors       = ["potato2003"]
  spec.email         = ["potato2003@gmail.com"]

  spec.summary       = "Google Stackdriver plugin for alerty"
  spec.description   = "Google Stackdriver plugin for alerty"
  spec.homepage      = "https://github.com/potato2003/alerty-plugin-stackdriver"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.license       = 'MIT'

  spec.add_runtime_dependency "alerty"
  spec.add_runtime_dependency "google-cloud-logging", "~> 1.5"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
