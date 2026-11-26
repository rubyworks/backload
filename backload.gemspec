require_relative 'lib/backload/version'

Gem::Specification.new do |s|
  s.name        = 'backload'
  s.version     = Backload::VERSION
  s.summary     = "Callbacks for Ruby's #require and #load"
  s.description = "Backload gives Ruby's #require, #require_relative and #load " \
                  'callbacks, before and after, so a program can see what is ' \
                  'loaded, when, and from inside what.'

  s.authors  = ['Trans']
  s.email    = ['transfire@gmail.com']
  s.homepage = 'https://github.com/rubyworks/backload'
  s.license  = 'BSD-2-Clause'

  s.metadata = {
    'source_code_uri'   => 'https://github.com/rubyworks/backload',
    'bug_tracker_uri'   => 'https://github.com/rubyworks/backload/issues',
    'changelog_uri'     => 'https://github.com/rubyworks/backload/blob/master/HISTORY.md',
    'documentation_uri' => 'https://rubydoc.info/gems/backload'
  }

  s.required_ruby_version = '>= 3.1'

  s.files         = Dir['lib/**/*.rb', 'README.md', 'HISTORY.md', 'LICENSE.txt']
  s.require_paths = ['lib']

  s.add_development_dependency 'rake', '>= 13'
  s.add_development_dependency 'rubytest', '>= 0.11.1'
  s.add_development_dependency 'spectrum', '>= 0.2'
  s.add_development_dependency 'assay', '>= 0.5.1'
end
