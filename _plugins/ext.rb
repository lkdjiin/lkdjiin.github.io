require 'jekyll/tagging'

module Jekyll
  module SortHashKeysFilter
    def sort_hash_keys(hash)
      hash.keys.sort_by { |k| k.to_s.downcase }.map { |k| [k, hash[k]] }
    end
  end
end

Liquid::Template.register_filter(Jekyll::SortHashKeysFilter)
