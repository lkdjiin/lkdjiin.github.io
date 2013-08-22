# Connexe plugin for Octopress.
#
# Description: Insert related posts inside the post.
#
# Syntax: {% connexe %}
#
# Customization:
# Add those lines in _config.yml and change their values like you want.
#   connexe_title: "Related posts"
#   connexe_maximum: 3

module Jekyll
  class ConnexeTag < Liquid::Block

    def initialize(tagname, markup, tokens)
    end

    def render(context)
      config = get_config(context)
      @categories = my_categories(context)
      return unless @categories
      @posts = get_posts(context)
      build_posts(context)
      build_output(config)
    end

    private

    def build_posts(context)
      remove_unrelated_posts
      remove_current_post(context)
      sort_posts
    end

    def remove_unrelated_posts
      @posts = @posts.select do |post|
        result = false
        @categories.each do |category|
          result = true if post.categories.include?(category)
        end
        result
      end
    end

    def remove_current_post(context)
      @posts.delete_if {|post| post.url == my_url(context)}
    end

    def sort_posts
      @posts = @posts.map do |post|
        weight = 0
        @categories.each do |category|
          weight += 1 if post.categories.include?(category)
        end
        [weight, post]
      end
      @posts = @posts.sort.reverse
    end

    def build_output(config)
      output = "<section>"
      output += "<h1>#{get_title(config)}</h1>"
      output += "<ul>"
      @posts[0, get_maximum(config)].each do |post|
        url = post.last.url
        title = post.last.data["title"]
        output += "<li><a href='#{url}'>#{title}</a></li>"
      end
      output += "</ul></section>"
      output
    end

    # Get an interface to config file (_config.yml).
    #
    # context - ? TODO review doc.
    #
    # Returns a Hash config.
    def get_config(context)
      context.registers[:site].config
    end

    # Get the head label (ie "Level: ").
    #
    # config - Hash configuration object.
    #
    # Returns String.
    def get_title(config)
      config['connexe_title'] || "Related posts"
    end

    def get_maximum(config)
      config['connexe_maximum'].to_i || 3
    end

    def my_categories(context)
      context.environments.first["page"]["categories"]
    end

    def get_posts(context)
      context.registers[:site].posts
    end

    def my_url(context)
      context.environments.first["page"]["url"]
    end

  end
end
Liquid::Template.register_tag('connexe', Jekyll::ConnexeTag)
