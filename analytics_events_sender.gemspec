# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'analytics_events_sender/version'

Gem::Specification.new do |spec|
  spec.name          = 'analytics_events_sender'
  spec.version       = AnalyticsEventsSender::VERSION
  spec.authors       = ['SumLare']
  spec.email         = ['anohin56n@gmail.com']

  spec.summary       = 'Event sender for multiple analuytics platforms'
  spec.description   = 'Event sender for multiple analuytics platforms'
  spec.homepage      = 'https://github.com/SumLare/analytics_events_sender'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
