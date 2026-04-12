# Jekyll Blog - Xavier Nayrac

## Commands
- `bundle exec jekyll serve` - local dev server (http://localhost:4000)
- `bundle exec jekyll build` - production build

## Setup
- Ruby 3.3.7 (`.ruby-version`)
- `bundle install` to install gems

## Site Structure
- `_posts/` - blog posts (markdown)
- `_layouts/` - HTML templates (home.html, post.html, tag.html)
- `_plugins/ext.rb` - custom Liquid filters
- `_includes/` - reusable series content (serie_*.md)
- `_site/` - generated output (do not edit)

## Notes
- Custom Rouge fork from `lkdjiin/rouge` branch `kickass`
- French date filter: `{{ date | french_date }}`
- Tag system via `jekyll-tagging` plugin
- Permalinks: `/blog/:year/:month/:day/:title/`
