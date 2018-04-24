lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'responder_bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'responder_bot'
  spec.version       = ResponderBot::VERSION
  spec.authors       = ['Jacob Evan Shreve']
  spec.email         = ['github@shreve.io']

  spec.summary       = 'A simple framework for defining a text-based interface'
  spec.description   = 'Use matchers to define a series of commands available' \
                       ' to an SMS or other chat interface so your users can ' \
                       'interact with just text.'
  spec.homepage      = 'https://github.com/shreve/responder_bot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
