# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'robinhood/tools/version'

Gem::Specification.new do |spec|
  spec.name          = "robinhood-tools"
  spec.version       = Robinhood::Tools::VERSION
  spec.authors       = ["Ian Lloyd"]
  spec.email         = ["ian.w.lloyd@gmail.com"]

  spec.summary       = %q{A simple collection of tools to process a Robinhood data summary.}
  spec.description   = %q{Convert data to OFX, etc...}
  spec.homepage      = "http://github.com/illoyd/robinhood-tools"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "workflow"
  spec.add_dependency "builder"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
