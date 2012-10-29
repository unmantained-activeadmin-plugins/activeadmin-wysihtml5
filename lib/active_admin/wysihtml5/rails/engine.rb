module ActiveAdmin
  module Wysihtml5
    module Rails
      class Engine < ::Rails::Engine
        engine_name "activeadmin_wysihtml5"

        initializer "precompile hook", group: :all do |app|
          app.config.assets.precompile += [
            "active_admin/wysihtml5.js",
            "active_admin/wysihtml5.css",
            "active_admin/editor/wysiwyg.css"
          ]
        end

        initializer "register resource" do
          ActiveAdmin.application.load_paths += [ File.expand_path('../admin', File.dirname(__FILE__)) ]
          ActiveAdmin.application.register_stylesheet "active_admin/wysihtml5.css", :media => :screen
          ActiveAdmin.application.register_javascript "active_admin/wysihtml5.js"
        end

      end
    end
  end
end
