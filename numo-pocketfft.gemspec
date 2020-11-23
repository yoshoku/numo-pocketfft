lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'numo/pocketfft/version'

Gem::Specification.new do |spec|
  spec.name          = 'numo-pocketfft'
  spec.version       = Numo::Pocketfft::VERSION
  spec.authors       = ['yoshoku']
  spec.email         = ['yoshoku@outlook.com']

  spec.summary       = <<~MSG
    Numo::Pocketfft provides functions for descrete Fourier Transform based on pocketfft.
  MSG
  spec.description = <<~MSG
    Numo::Pocketfft provides functions for descrete Fourier Transform based on pocketfft.
  MSG
  spec.homepage      = 'https://github.com/yoshoku/numo-pocketfft'
  spec.license       = 'BSD-3-Clause'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  # Add files in submodule: https://gist.github.com/mattconnolly/5875987
  gem_dir = __dir__ + '/'
  `git submodule --quiet foreach pwd`.split($OUTPUT_RECORD_SEPARATOR).each do |submodule_path|
    Dir.chdir(submodule_path) do
      submodule_relative_path = submodule_path.sub gem_dir, ''
      `git ls-files`.split($OUTPUT_RECORD_SEPARATOR).each do |filename|
        spec.files << "#{submodule_relative_path}/#{filename}"
      end
    end
  end

  spec.require_paths = ['lib']
  spec.extensions    = ['ext/numo/pocketfft/extconf.rb']

  spec.metadata      = {
    'homepage_uri' => 'https://github.com/yoshoku/numo-pocketfft',
    'changelog_uri' => 'https://github.com/yoshoku/numo-pocketfft/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/yoshoku/numo-pocketfft',
    'documentation_uri' => 'https://yoshoku.github.io/numo-pocketfft/doc/',
    'bug_tracker_uri' => 'https://github.com/yoshoku/numo-pocketfft/issues'
  }

  spec.add_runtime_dependency 'numo-narray', '~> 0.9.1'
end
