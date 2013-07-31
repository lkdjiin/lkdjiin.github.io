# Level tag plugin for Octopress.
#
# Description: Add a level description to a post.
#
# Syntax: {% level 1|2|3 %}
#
# Examples:
# {% level 1 %}
#
# Output:
# <div class="level-tag level-tag-1">Level : <span>easy</span></div>
#
# Customization:
# Add those lines in _config.yml and change their values like you want.
#   level_tag_level: "Level: "
#   level_tag_level_1: "easy"
#   level_tag_level_2: "medium"
#   level_tag_level_3: "hard"

module Jekyll
  class LevelTag < Liquid::Tag

    def initialize(tagname, level, tokens)
      @level = level.strip
    end

    def render(context)
      cfg = get_config(context)
      html_output(get_head(cfg), get_level(cfg))
    end

    private

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
    def get_head(config)
      config['level_tag_level'] || "Level: "
    end

    # Get the «level description» label (ie "easy" or "hard").
    #
    # config - Hash configuration object.
    #
    # Returns String.
    def get_level(config)
      case @level
      when "1" then config['level_tag_level_1'] || "easy"
      when "2" then config['level_tag_level_2'] || "medium"
      when "3" then config['level_tag_level_3'] || "hard"
      else
        "unknown"
      end
    end

    # Produce html output for given head and level description.
    #
    # head  - String heading.
    # level - String level description.
    #
    # Returns String html code to insert in the post.
    def html_output(head, level)
      classes = "class='level-tag level-tag-#{@level}'"
      "<div #{classes}>#{head}<span>#{level}</span></div>"
    end

  end

end
Liquid::Template.register_tag('level', Jekyll::LevelTag)
