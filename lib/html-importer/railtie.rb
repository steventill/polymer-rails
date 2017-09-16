module HtmlImporter
  module Rails
    class Railtie < ::Rails::Railtie

      initializer :html_import do
        ::ActionView::Base.module_eval('include AssetTagHelper')
      end

      initializer :add_preprocessors do |app|
        add_preprocessors(app)
      end

      private

      def add_preprocessors(app)
        app.config.assets.configure do |env|
          env.context_class.class_eval("include HtmlImporter::Rails::AssetTagHelper")
          env.register_preprocessor 'text/html', HtmlImporter::Rails::Processors::Directive
          env.register_mime_type 'text/html', extensions: ['.html']
          env.register_bundle_processor 'text/html', ::Sprockets::Bundle
          env.register_postprocessor 'text/html', HtmlImporter::Rails::Processors::Component
        end
      end
    end
  end
end
