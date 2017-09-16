module HtmlImporter
  module Rails
    module XmlAdapters
      class Base

        # HTML Encoding
        ENCODING = 'UTF-8'

        def self.factory
          klass = "#{parent}::#{RUBY_PLATFORM =~ /java/ ? 'Jsoup' : 'Nokogiri'}"
          klass.constantize.new
        end

      end
    end
  end
end

if RUBY_PLATFORM =~ /java/
  require "html-importer/xml_adapters/jsoup"
else
  require "html-importer/xml_adapters/nokogiri"
end
