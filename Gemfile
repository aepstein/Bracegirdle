source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.2.1'

# Use Puma as the app server
gem 'puma'

# Use SCSS for stylesheets
gem 'sassc-rails'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
 gem 'bcrypt'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Capistrano for deployment
gem 'capistrano', group: :development
gem 'capistrano-rails', group: :development
gem 'capistrano-rvm', group: :development
gem 'capistrano3-puma', group: :development

# Use PostgreSQL for production
gem 'pg'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  #gem 'rspec-rails'
  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git', branch: 'master'
  gem 'rspec-retry'
  gem 'factory_bot_rails'
  gem 'travis'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'rack_session_access'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  #gem 'web-console'
  #gem 'listen'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'better_errors'
  gem 'binding_of_caller'
end


group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'capybara-select-2'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'database_cleaner'

  # To determine test coverage
  gem 'simplecov', '< 0.18', require: false

  # To test PDFs
  gem 'pdf-inspector'

  # To stub request
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# For geocoding cemetery locations
gem 'geocoder'

gem "rubyzip"

# For Slim templates
gem "slim"

# For submitting files through Ajax
gem 'remotipart'

# For generating PDFs
gem 'prawn'
gem 'prawn-table'
gem 'combine_pdf'
gem 'squid'

# For using PDF.js with Rails
gem 'pdfjs_viewer-rails'

# Language processing
gem 'numbers_and_words'
gem 'indefinite_article'

# For Auth0
gem 'omniauth'
gem 'omniauth-auth0'
#gem 'omniauth-rails_csrf_protection'

gem "pundit"
