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
    `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features|sig-deps)/) }
                     .select { |f| f.match(/\.(?:rb|rbs|h|c|md|txt)$/) }
  end

  spec.require_paths = ['lib']
  spec.extensions    = ['ext/numo/pocketfft/extconf.rb']

  spec.metadata      = {
    'homepage_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/blob/main/CHANGELOG.md",
    'source_code_uri' => spec.homepage,
    'documentation_uri' => "https://gemdocs.org/gems/#{spec.name}/#{spec.version}/",
    'bug_tracker_uri' => "#{spec.homepage}/issues"
  }

  spec.add_runtime_dependency 'numo-narray-alt', '~> 0.9.3'
end
