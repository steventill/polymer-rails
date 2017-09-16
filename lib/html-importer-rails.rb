require "sprockets"
require "html-importer/version"
require "html-importer/xml_adapters/base"
require "html-importer/processors/directive"
require "html-importer/processors/component"
require "html-importer/helpers/asset_tag_helper"
require "html-importer/railtie" if defined?(::Rails)
