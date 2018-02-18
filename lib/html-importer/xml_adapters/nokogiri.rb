require 'nokogiri'
require 'nokogumbo'

module HtmlImporter
  module Rails
    module XmlAdapters
      class Nokogiri < Base

        # XML options for to_xml method
        XML_OPTIONS = { save_with: ::Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS }

        # Nodes that should be parsed as XML nodes
        # URI attributes are determined by using the attributes list at https://html.spec.whatwg.org/#attributes-3
        # and looking for attributes that specify "Valid URL" as their values
        URI_ATTRIBUTES = %w(
          action
          cite
          data
          formaction
          href
          itemid
          manifest
          ping
          poster
          src
        ).freeze

        # URI attributes are determined by using the attributes list at https://html.spec.whatwg.org/#attributes-3
        # and looking for attributes that specify "Boolean attribute" as their values
        BOOLEAN_ATTRIBUTES = %w(
          allowfullscreen
          allowpaymentrequest
          allowusermedia
          async
          autofocus
          autoplay
          checked
          controls
          default
          defer
          disabled
          formnovalidate
          hidden
          ismap
          itemscope
          loop
          multiple
          muted
          nomodule
          novalidate
          open
          playsinline
          readonly
          required
          reversed
          selected
        ).freeze

        def parse_document data
          ::Nokogiri::HTML5 data
        end

        def create_node doc, name, content
          node = ::Nokogiri::XML::Node.new(name, doc)
          node.content = content
          node
        end

        def replace_node old_node, new_node
          old_node.replace new_node
        end

        def stringify doc
          xml_nodes(doc).reduce(to_html(doc)) do |output, node|
            pattern = node.to_html
            replacement = node.to_xml(XML_OPTIONS)
            replacement.gsub!( /src="%5B%5B(.+?)%5D%5D"/i, 'src="[[\1]]"' )
            replacement.gsub!( /src="%7B%7B(.+?)%7D%7D"/i, 'src="{{\1}}"' )
            output.gsub(pattern, replacement).encode(ENCODING)
          end
        end

        def css_select doc, selector
          doc.css selector
        end

        private
        def xml_nodes doc
          selectors = (URI_ATTRIBUTES + BOOLEAN_ATTRIBUTES).map { |attribute| "*[#{attribute}]"}
          doc.css(selectors.join(','))
        end
        def to_html doc
          doc.css("head,body").children.to_html(encoding: ENCODING).lstrip
        end
      end
    end
  end
end
