$:.push File.expand_path("../lib", __FILE__)

require "active_admin/wysihtml5/version"

Gem::Specification.new do |s|
  s.name        = "activeadmin-wysihtml5"
  s.version     = ActiveAdmin::Wysihtml5::VERSION
  s.authors     = ["Eric Holmes", "Stefano Verna"]
  s.email       = ["eric@ejholmes.net", "s.verna@cantierecreativo.net"]
  s.homepage    = "https://github.com/cantierecreativo/activeadmin-wysihtml5"
  s.summary     = "Rich text editor for Active Admin using wysihtml5."
  s.description = s.summary

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "README.md"]

  s.add_dependency "activeadmin"
  s.add_dependency "activeadmin-dragonfly", "~> 0.1"
end

