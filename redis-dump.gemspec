# frozen_string_literal: true

require_relative "lib/redis/dump/version"

Gem::Specification.new do |spec|
  spec.name        = "redis-dump"
  spec.version     = Redis::Dump::VERSION
  spec.authors     = ["delano"]
  spec.email       = "gems@solutious.com"

  spec.summary     = "Backup and restore your Redis data to and from JSON."
  spec.description = "Backup and restore your Redis data to and from JSON by database, key, or key pattern."
  spec.homepage    = "https://rubygems.org/gems/redis-dump"
  spec.license     = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.8")

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{\A(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
