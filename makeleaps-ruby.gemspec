
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "makeleaps/version"

Gem::Specification.new do |spec|
  spec.name                  = "v-makeleaps-ruby"
  spec.version               = Makeleaps::VERSION
  spec.authors               = ["Koji Onishi", "Hieu Nguyen"]
  spec.email                 = ["nguyen.trung.hieu@vareal.vn"]

  spec.summary               = 'A Ruby-based, thin wrapper gem for Makeleaps API'
  spec.description           = 'A third-party (unofficial) Makeleaps API client. Provides you a simple and intuitive access to Makeleaps API'
  spec.homepage              = 'https://github.com/vareal/makeleaps-ruby'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.3.0'

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"]      = 'https://github.com/vareal/makeleaps-ruby'
    spec.metadata["source_code_uri"]   = 'https://github.com/vareal/makeleaps-ruby'
    # spec.metadata["changelog_uri"]     = "TODO: Put your gem's CHANGELOG.md URL here."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '1.10'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'
  spec.add_development_dependency 'vcr',     '>= 5.0'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency "hashdiff", ">= 1.0.0.beta1", "< 2.0.0"

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
end
