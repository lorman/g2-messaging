lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "g2/messaging/version"

Gem::Specification.new do |spec|
  spec.name          = "g2-messaging"
  spec.version       = G2::Messaging::VERSION
  spec.authors       = ["Michael Wheeler"]
  spec.email         = ["mwheeler@g2crowd.com"]

  spec.summary       = %q{Standardize the message bus for different microservices}
  spec.homepage      = 'https://www.g2crowd.com'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://gems.g2crowd.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "king_konf"
  spec.add_dependency "racecar", "0.3.7"
  spec.add_dependency "connection_pool", "2.2.1"
  spec.add_dependency "activesupport", ">= 3.0"
  spec.add_dependency "activemodel", ">= 3.0"
  spec.add_dependency "ruby-kafka", '0.5.5'
  spec.add_dependency "json_schema_tools", '0.6.6'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3.1"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "pry"
end
