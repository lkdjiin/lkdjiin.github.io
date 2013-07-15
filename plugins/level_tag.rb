# Level tag plugin for Octopress.
#
# Description: Add a level label to a post.
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
      config = context.registers[:site].config
      label = config['level_tag_level'] || "Level: "
      level = case @level
      when "1" then config['level_tag_level_1'] || "easy"
      when "2" then config['level_tag_level_2'] || "medium"
      when "3" then config['level_tag_level_3'] || "hard"
      else
        "unknown"
      end
      classes = "class='level-tag level-tag-#{@level}'"
      "<div #{classes}>#{label}<span>#{level}</span></div>"
    end

  end

end
Liquid::Template.register_tag('level', Jekyll::LevelTag)
