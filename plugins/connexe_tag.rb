module Jekyll
  class ConnexeTag < Liquid::Tag

    def initialize(tagname, str, tokens)
    end

    def render(context)
      # categories = get_categories(context)
      # posts = get_posts(context)

      # 1 Supprimer les posts qui n'ont pas au moins une
      #   catégorie commune.
      # posts = posts.select do |post|
      #   result = false
      #   categories.each do |cat|
      #     result = true if post.categories.include?(cat)
      #   end
      #   result
      # end
      # posts.inspect

      # 2 Supprimer le post courant.

      # 3 Attribuer un poid.

      # categories.size
      context.environments.first["page"]["categories"].size
    end

    private

    def get_categories(context)
      context.environments.first["page"]["categories"]
    end
    def get_posts(context)
      # context.registers[:site].posts.last.url
      context.registers[:site].posts
    end

  end
end
Liquid::Template.register_tag('connexe', Jekyll::ConnexeTag)
