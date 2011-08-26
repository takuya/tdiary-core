source :rubygems

gem 'rack'
gem 'rake'

group :development do
  gem 'thin', :platforms => :ruby
  gem 'capistrano'
  gem 'pit'
end

group :test do
  gem 'rspec'
  gem 'fuubar'

  gem 'jasmine'

  gem 'rcov', :platforms => :mri_18
  gem 'cover_me', :platforms => :mri_19

  gem 'nokogiri', '~> 1.4.7' # for ruby-1.8.6
  gem 'capybara-webkit'
  gem 'capybara-mechanize', '~> 0.3.0.rc2', :require => 'capybara/mechanize'
  gem 'launchy'
end
