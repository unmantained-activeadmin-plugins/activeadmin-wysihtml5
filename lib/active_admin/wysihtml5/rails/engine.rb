module ActiveAdmin
  module Wysihtml5
    module Rails
      class Engine < ::Rails::Engine
        engine_name "activeadmin_wysihtml5"

        initializer "precompile hook", group: :all do |app|
          app.config.assets.precompile += [
            "activeadmin-wysihtml5/base.js",
            "activeadmin-wysihtml5/base.css",
            "activeadmin-wysihtml5/wysiwyg.css"
          ]
        end

        initializer "register resource" do
          ActiveAdmin.application.load_paths += [ File.expand_path('../admin', File.dirname(__FILE__)) ]
          ActiveAdmin.application.register_stylesheet "activeadmin-wysihtml5/base.css", :media => :screen
          ActiveAdmin.application.register_javascript "activeadmin-wysihtml5/base.js"
        end

      end
    end
  end
end
