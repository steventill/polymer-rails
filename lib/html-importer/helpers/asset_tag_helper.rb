module HtmlImporter
  module Rails
    module AssetTagHelper
      def html_import_tag(*sources)
        options = sources.extract_options!
        path_options = options.extract!('protocol').symbolize_keys
        
        sources.uniq.map do |source|
          _html_import_tag source, options, path_options
        end.join("\n").html_safe
      end
      
      def _html_import_tag source, options, path_options
        tag_options = { 
          rel: "import", 
          href: path_to_asset(source, {type: :html, extname: '.html'}.merge!(path_options))
        }
  
        tag(:link, tag_options.merge!(options).stringify_keys)
      end
    end
  end
end
