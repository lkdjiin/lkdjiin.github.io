module Jekyll

  class MathJaxBlockTag < Liquid::Tag
    def render(context)
      "$$\n\\begin{align}\n"
    end
  end

  class MathJaxEndTag < Liquid::Tag
    def render(context)
      "\\end{align}\n$$"
    end
  end

end
 
Liquid::Template.register_tag('math', Jekyll::MathJaxBlockTag)
Liquid::Template.register_tag('endmath', Jekyll::MathJaxEndTag)
