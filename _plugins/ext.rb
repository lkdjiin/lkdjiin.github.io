require 'jekyll/tagging'

module Jekyll
  module SortHashKeysFilter
    def sort_hash_keys(hash)
      hash.keys.sort_by { |k| k.to_s.downcase }.map { |k| [k, hash[k]] }
    end
  end

  module FrenchDateFilter
    FRENCH_MONTHS = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ].freeze

    def french_date(date)
      day = date.strftime('%d').to_i
      month = FRENCH_MONTHS[date.strftime('%-m').to_i - 1]
      year = date.strftime('%Y')
      "#{day} #{month} #{year}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::SortHashKeysFilter)
Liquid::Template.register_filter(Jekyll::FrenchDateFilter)
