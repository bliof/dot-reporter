# frozen_string_literal: true

require_relative 'lib/dot_reporter/version'

Gem::Specification.new do |spec|
  spec.name          = 'dot-reporter'
  spec.version       = DotReporter::VERSION
  spec.authors       = ['Jules']
  spec.email         = ['jules@example.com']

  spec.summary       = 'Beautiful test output. 8 dots per character.'
  spec.description   = 'Minimal, elegant test formatter for RSpec and Minitest. Displays test results as Unicode dot patterns - 8 tests per character.'
  spec.homepage      = 'https://github.com/bliof/dot-reporter'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/bliof/dot-reporter/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'minitest', '>= 5.20'
  spec.add_dependency 'rspec-core', '>= 3.12'
end
