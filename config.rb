require 'slim'
Slim::Engine.disable_option_validator!
Time.zone = 'Eastern Time (US & Canada)'

require 'sass-media_query_combiner'
require "helpers/custom_helpers"
helpers CustomHelpers

set :site_url, 'https://sagarkrkv.github.io'
set :site_domain, 'sagarkrkv.github.io'
set :site_title, 'Vidya Sagar Kalvakunta | Software Engineer'
set :site_author, 'Vidya Sagar Kalvakunta'
set :site_description, 'Personal website and blog.'
set :site_author_image, 'avatar.png'
set :social_github, 'https://github.com/sagarkrkv'
set :social_linkedin, 'https://www.linkedin.com/in/sagarkrkv'
set :disqus_shortname, 'sagarkrkv'
set :twitter, '@umdevUX'
set :social_twitter, 'https://twitter.com/umdevUX'
set :social_instagram, 'https://instagram.com/umdevux'


activate :blog do |blog|
  blog.permalink = "/{title}"
  blog.sources = "posts/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tags/{tag}.html"

  blog.summary_separator = /(READMORE)/

  blog.year_link = "{year}.html"
  blog.month_link = "{year}/{month}.html"
  blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".{markdown,md}"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end

# i18n
activate :i18n do |l|
  l.path = "/:locale/"
  l.mount_at_root = :en
  l.no_fallbacks = true
end

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false
page "/blog.html", layout: "blog"
page "/posts/*.html", layout: "posts"

# Title
activate :title, site: 'Vidya Sagar Kalvakunta | Software Engineer', separator: ' — '

# Metatags
activate :meta_tags

# Sitemap
set :url_root, 'https://sagarkrkv.github.io/'
activate :search_engine_sitemap, default_priority: 0.5,
                                 default_change_frequency: "always"

compass_config do |config|
  config.output_style = :expanded
  config.line_comments = false
end

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'

activate :directory_indexes
set :index_file, "index.html"
page "/404.html", :directory_index => false

# syntax
activate :syntax
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true,
               :autolink => true,
               :smartypants => true

activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 9']
  # config.ignore   = ['source/assets/stylesheets/vendors/']
end


# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :gzip
  # activate :asset_hash
  activate :cache_buster
  set :google_analytics_account, 'UA-91533048-1'
  activate :automatic_image_sizes
  activate :automatic_alt_tags
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.remote = "origin"
  deploy.branch = "master"

  committer_app = "#{Middleman::Deploy::PACKAGE} v#{Middleman::Deploy::VERSION}"
  commit_message = "Deployed using #{committer_app}"

  if ENV["TRAVIS_BUILD_NUMBER"] then
    commit_message += " (Travis Build \##{ENV["TRAVIS_BUILD_NUMBER"]})"
  end

  deploy.commit_message = commit_message
end

configure :development do
  Slim::Engine.default_options[:pretty] = true
  set :debug_assets, true
  activate :livereload
end
