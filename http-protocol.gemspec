Gem::Specification.new do |s|
  s.name = "http-protocol"
  s.version = '0.0.1.5'
  s.summary = "HTTP protocol library designed to facilitate custom HTTP clients"
  s.description = ' '

  s.authors = ['Obsidian Software, Inc']
  s.email = 'opensource@obsidianexchange.com'
  s.homepage = 'https://github.com/obsidian-btc/http-protocol'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'telemetry-logger'

  s.add_development_dependency 'test_bench'
end
