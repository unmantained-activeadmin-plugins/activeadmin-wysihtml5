$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/wysihtml5/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin-wysihtml5"
  s.version     = ActiveAdmin::Wysihtml5::VERSION
  s.authors     = ["Eric Holmes"]
  s.email       = ["eric@ejholmes.net"]
  s.homepage    = "https://github.com/ejholmes/active_admin_editor"
  s.summary     = "Rich text editor for Active Admin using wysihtml5."
  s.description = s.summary

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activeadmin", "~> 0.5"
end
