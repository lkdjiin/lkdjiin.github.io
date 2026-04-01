# AGENTS.md - AI Coding Agent Guide

## Project Overview

This is a **Jekyll static site** for a personal blog hosted on GitHub Pages.

- **Language**: French (content), Ruby (plugins), HTML/CSS/JS (templates)
- **Framework**: Jekyll 4.4.x with Minima theme
- **Ruby version**: 3.1.7 (see `.ruby-version`)
- **URL**: https://lkdjiin.github.io

## Build & Development Commands

```bash
# Install dependencies
bundle install

# Start local dev server (http://localhost:4000)
bundle exec jekyll serve

# Build static site to _site/
bundle exec jekyll build

# Clean generated files
bundle exec jekyll clean

# Serve with live reload
bundle exec jekyll serve --livereload
```

**No formal test suite or linting** exists in this project. Verification is done by building the site and checking output manually.

## Project Structure

```
.
├── _config.yml          # Site configuration
├── _layouts/            # Page templates (home.html, post.html)
├── _includes/           # Reusable HTML partials
├── _plugins/            # Custom Liquid tags (Ruby)
├── _posts/              # Blog articles (Markdown)
├── assets/              # CSS stylesheets
├── images/              # Image files
├── Gemfile              # Ruby dependencies
└── .ruby-version        # Ruby version (3.1.7)
```

## Code Style Guidelines

### Ruby Plugins (`_plugins/`)

- Inherit from `Liquid::Tag` or `Liquid::Block`
- Register tags with `Liquid::Template.register_tag('tag_name', ClassName)`
- Use regex constants for parsing markup
- Keep plugins minimal and focused on one task
- No trailing newline after closing `end`

```ruby
module Jekyll
  class MyTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      # parse markup
      super
    end

    def render(context)
      # return HTML string
    end
  end
end

Liquid::Template.register_tag('mytag', Jekyll::MyTag)
```

### Liquid Templates (`_layouts/`, `_includes/`)

- Use **2-space indentation**
- Use whitespace-trimming tags: `{%- -%}` and `{{- -}}`
- Keep logic minimal; prefer includes for reuse
- Use `relative_url` filter for internal links
- Escape user content with `| escape`

### HTML

- Semantic HTML5 elements
- Microdata for SEO: `itemprop`, `itemscope`, `itemtype`
- Minimal inline styles (use CSS classes instead)

### CSS (`assets/`)

- One stylesheet per concern (syntax highlighting, layout, etc.)
- No build pipeline; plain CSS served directly
- Syntax theme files: `perldoc.css`, `monokai.css`, `zenburn.css`, etc.

### Markdown Posts (`_posts/`)

**File naming**: `YYYY-MM-DD-slug.markdown`

**Front matter format**:
```yaml
---
layout: post
title: "Article Title"
date: YYYY-MM-DD HH:MM
comments: true
tags: [ tag1, tag2 ]
---
```

**Content conventions**:
- Use `{% highlight lang %}...{% endhighlight %}` for code blocks
- Use `{% img center /images/filename.png %}` for images
- Use `<!-- more -->` to split excerpt from full post
- Use `{% include filename.html %}` for reusable content blocks
- Write in French

### Date Format

Site-wide date format: `%d %B %Y` (e.g., "18 mars 2026")

### Permalink Structure

`/blog/:year/:month/:day/:title/`

## Custom Liquid Tags

| Tag | File | Usage |
|-----|------|-------|
| `{% blockquote Author URL Title %}...{% endblockquote %}` | `blockquote.rb` | Styled blockquote with citation |
| `{% img [class] path [width height] [title] %}` | `image_tag.rb` | Responsive image tag |
| `{% math %}...{% endmath %}` | `math.rb` | MathJax block equations |
| `{% highlight lang %}...{% endhighlight %}` | Jekyll built-in | Syntax highlighted code |

## Key Configuration (`_config.yml`)

- **theme**: `minima`
- **plugins**: `jekyll-feed`, `jekyll-sitemap`
- **permalink**: `/blog/:year/:month/:day/:title/`
- **syntax highlighter**: Custom Rouge fork (`git@github.com:lkdjiin/rouge.git`, branch `kickass`)

## Adding New Content

1. Create file in `_posts/` with name `YYYY-MM-DD-slug.markdown`
2. Add YAML front matter (layout, title, date, tags)
3. Write content in French using Markdown
4. Add images to `images/` directory
5. Run `bundle exec jekyll serve` to preview
6. Commit and push to deploy via GitHub Pages
